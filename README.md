#Interleave

* An application for managing longitudinal clinical research databases and registries that is based on the OHDSI/OMOP Common Data Model (CDM).
* The application layers the following features on top of the CDM.
 * Multitenant housing of registires.
 * Enrichment of the CDM to include protected health imformation fields.
 * Registry-scoped configuration of datapoints and the relationshpe between datapoints.  Dynamic diplay of datapoints per peson per registry.
 * Datapoint restriction of the list of possible values of CDM concept ID values.
 * Provenance tracking per CDM entity back to source system rows.
 * Support for the incremental load of data from an outside source sytem.
 * A user interface to allow for the creation 'ex nihlo' of any CDM entity.
 * A user interface to allow for the overide of any externally imported CDM entity.


* Why the name 'Interleve'?
  * Because clinical reserach databases and registries requrie the 'inteleaving' of manually created data and data automatically pulled from external systems (EHRs, billing/claims systems...)?  Data must be stacked on top of each other and the provenance of each entity must be tracked.  The data must be interleaved.

* Setup
 * Open a psql command prompt
 * CREATE DATABASE interleave_development;
 * CREATE USER interleave_development WITH CREATEDB PASSWORD 'interleave_development';
 * ALTER DATABASE interleave_development OWNER TO interleave_development;
 * ALTER USER interleave_development SUPERUSER;
 * CREATE DATABASE interleave_test;
 * CREATE USER interleave_test WITH CREATEDB PASSWORD 'interleave_test';
 * ALTER DATABASE interleave_test OWNER TO interleave_test;
 * ALTER USER interleave_test SUPERUSER;
 * bundle exec rake db:migrate
 * bundle exec rake setup:interleave_registries