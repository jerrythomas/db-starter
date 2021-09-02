# README

The database scripts have been written in a way that will support applying incremental releases and at the same time maintan a consistent current database structure in version control.

The following gruidelines should be followed when making changes.

- The following files should contain scripts to create the current release version of the database for the corresponding object types.
  - extensions.ddl
  - schemas.ddl
  - tables.ddl
  - views.ddl

Environment specific data load scripts should ensure that the data tables are first truncated before loading data. These should be in the `data/testing` or `data/development` folders.

## Incremental changes

Incremental changes involve

- new objects
- alterations to existing objects
- alterations to views
- new metadata inserted
- old metadata updated
- environment specific data inserted/updated

## Guidelines

- Any changes or addition of any database object type should always be updated in the scripts corresponding to the object types. For example an addition of a new `table` should go into the `tables.ddl`.
- An alter script should be created which contains the incremental changes. For example addition of a new column should go into the `alter.ddl` script. The original table definition should also be updated in `tables.ddl`. This will ensure that `tables.ddl` always has the up to date version of the table structures and we can run full release builds also.
- Initial metadata is loaded using the `metadata.sql` script using postgresql copy command. This relies on the data files in csv format.
- Sometimes changes include data corrections and additions. These changes should be added to the `incremental.sql` file. The corresponding rollback insert/update/delete steps should be added to `rollback/data.sql`

## Supporting rollbacks

- When altering views, the previous version of views should be copied over to rollback/views.ddl.
- For environment specific data copy over the previous version to data/testing or data/development.
- For any metadata updates and inserts, ensure that the rollback/data.sql contains appropriate code to reverse the changes of current release.

## Applying a release

Set the environment variables

```bash
export DATABASE_URL=postgresql://${USER}:${PASS}@localhost/cb-dev
export ENV=development
```

```bash
./release.sh
```

## Rolling back a release

```bash
./rollback.sh
```

## Running a custom script for an environment

The script should be present in the `data/\$ENV` directory

```bash
./env_script.sh <your-script.sql>
```

## Using dbml for data dictionary

Design files are present in the design folder and the resulting documentation can be shared using [dbdocs.io](https://dbdocs.io)

```bash
dbdocs login
dbdocs build design/schemas.dbml
```