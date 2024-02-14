---
title: "Database schema changes at scale"
layout: post
date: 2024-02-14 18:00
image: /assets/images-posts/database-schema.png
headerImage: true
tag:
- software
- databases
category: blog
author: sinclert
description: "A summary of the challenges executing SQL schema changes at scale"
---

## Index

- [Introduction](#Introduction)
- [Database schema evolution](#database-schema-evolution)
- [Challenges](#challenges)
    - [1. Table locks](#1-table-locks)
    - [2. Development speed](#2-development-speed)
- [Tradeoffs](#trade-offs)
- [Missing topics](#missing-topics)


## Introduction
Most software projects rely on a database to store its related data. When considering
database options, the most popular ones are the ones relying on a fixed structure
data needs to fit into. These databases are usually called _SQL_ databases, and
the structure they rely on _schema_.

A database _schema_ is the set of tables and views that classify how data is stored,
and how it can be accessed. Usually, projects define an initial schema for its database,
and slowly evolve it over time, as new features and requirements rise from the daily use.

This last part, how the schema evolves, is an interesting challenge when considering the scale
some SQL databases reach.


## Database schema evolution
When considering how to evolve a SQL database schema, there is a range of common operations
developers can carry out.

On one hand, there is the creation / removal of high level structures such as tables or views.
When doing right, these operations add very little load to the database, as there is not much
logic to apply, nor data transformation to perform. They are simple operations that can be
carried out alongside regular read / write traffic.

On the other hand, there is the modification of those structures, represented by the operations that
allow developers to alter a table, either by creating, changing or removing columns, indexes and foreign keys.
Usually, these operations add enough load to the database to be conscious about when to execute them.
Specifics depend on the SQL database of choice, but as the volume of data in a table increases, so does
the pressure the schema change will put on the database.


## Challenges

### 1. Table locks

#### Problem description
Modern databases use table locks to protect the integrity of the data they hold.
Locks are _not_ a bug, but a system feature, purposely designed to prevent data corruption
when inserting or updating values to something that may not compatible with the defined schema.

Take `UNIQUE` indexes as an example: when a table contains a few of them, every new record
that gets inserted must validate uniqueness over all the records the table already contains,
adding a few milliseconds of latency to the operation. This additional latency is neglectable
in small tables (< 10 GBs), but adds up as the size increases.

The same happens with schema changes: SQL databases need to acquire a table lock
in order to apply schema changes that alter the structure of already existing tables.
As you can imagine, **the bigger the table, the longer the lock is held**,
ranging from a few seconds when a table is in the order of GBs,
to several minutes as a table data approaches the TB scale.

Traffic intensive applications cannot afford this.

#### Solution
The solution to this problem has been known for many years now: _online schema changes_ (OST).

Online schema changes comprises a range of techniques allowing developers to evolve
the schema of their application database, without suffering downtime due to table locks.
To avoid it, they all follow a similar strategy:

1. Create a new table with the desired schema (called _shadow table_)
2. Start copying batches of records from the original table to the _shadow table_.
3. Replicate every data operation targeting the original table to the _shadow table_
(via triggers or binary logs).

When the record copying part of the process is done, the _shadow table_ will be on sync
with the original, meaning, they both will contain the same exact data. At that point,
the tool that gets used to execute the online schema changes, needs to:

1. Stop the replication.
2. Do an atomic rename, so that the _shadow table_ takes the _original table_ name.

Of course, performing an online schema-change adds load to the database,
but when run sequentially, it is a load that all databases can handle.
That is how table locks are avoided, and downtime greatly reduced.


### 2. Development speed

#### Problem description
The usage of online schema-change tooling is not new. Projects like [Percona OST][percona-ost]
or [gh-ost][github-ost] (GitHub Online Schema-migrations Tool) have been around for almost a decade,
and they are a popular solution to run SQL schema-changes at scale.

However, the usage of OST techniques comes at the cost of database load and decreased development speed.
First, database load during the execution of such schema changes will increase, as every data related
operation (`INSERT`, `UPDATE`, `DELETE`) targeting the migrated table needs to be duplicated.
Second, the pace at which the application codebase can evolve will decrease, as the schema-changes will
take longer to execute due to the data copying process between the _original table_ and the _shadow table_.

When using OST techniques on projects where hundreds of developers collaborate, the difference between
the speed at which the application codebase can evolve, and the speed at which the database schemas
can be changed, increases. This phenomenon slows down code deployments, as deployments relying on
a database schema change need to wait until the previous deployment has finished, which may take hours,
depending on the migrated table size.

#### Potential solution
One of the solutions to this problem is to **decouple** application deployments from database schema-change
deployments, which sounds easier said that done.

Decoupling codebase and database schema evolution implies that developers need to adapt to a new workflow,
where each new code change needs to be done after the column, index or table it relies on reaches the desired
state. With this workflow, working on a feature would require at least two Pull Requests:
one with the database schema modification first, and a follow-up with all the code changes.

Sadly, that is only part of the solution. The other aspect to consider is how to make database schema-changes
not delay the whole deployment pipeline.

To solve this problem, a different _deployment queue_ need to be put in place, to store and process
schema-changes at a pace different to the one of the code changes. With this approach, the "deployment"
of schema-changes fasten, as they would not get applied at deployment time, but serialized and submitted
to an external service, in charge of managing them.


## Trade-offs
It must be clear by now that _there is no free lunch_, as software engineers like to say.
Executing SQL schema-changes at scale is a delicate balance between downtime, increased database load,
and compromises to development speed.

Ideally, the sweet spot is reached when:
- **Downtime** is kept to a minimum. Only an atomic table rename is needed, when using an OST technique.
- **Database load** is kept under control, by only running one schema-change simultaneously.
- **Schema evolution** is decoupled from code changes, so it can be process at its own pace.


## Missing topics
This blog post lacks details **on purpose**.

The idea is to expose the readers to some of the challenges of running SQL schema-changes at scale,
as well as present a high level overview of the techniques to tackle them. Technicalities over
the type of SQL database chosen, the nuances across the different OST approaches, or better ways
to decouple application logic and database evolution is something the readers must find out on their own.

For more details about OST techniques, read this [great article][planet-scale-ost-doc] by Planet Scale.


[github-ost]: https://github.com/github/gh-ost
[percona-ost]: https://docs.percona.com/percona-toolkit/pt-online-schema-change.html
[planet-scale-ost-doc]: https://planetscale.com/docs/learn/how-online-schema-change-tools-work
