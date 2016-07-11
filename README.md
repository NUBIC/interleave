#Interleave

* An application for managing longitudinal clinical research databases and registries that is based on the OHDSI/OMOP Common Data Model (CDM).
* The application layers the following features on top of the CDM.
 * Multitenant housing of registries.
 * Enrichment of the CDM to include protected health information fields.
 * Registry-scoped configuration of datapoints and the relationshpe between datapoints.  Dynamic display of datapoints per peson per registry.
 * Datapoint restriction of the list of possible values of CDM concept ID values.
 * Provenance tracking per imported standardized CDM clinical entity back to source system rows.
 * Support the incremental load of data from multiple outside source systems.
 * A user interface to allow for the creation 'ex nihlo' of standardized CDM clinical entities.
 * A user interface to allow for the override of externally imported standardized CDM clinical entities.

* Why the name 'Interleve'?
  * Because clinical reserach databases and registries requrie the 'inteleaving' of manually created data and data automatically pulled from external systems (EHRs, billing/claims systems...)?  Data must be stacked on top of each other and the provenance of each entity must be tracked.  The data must be interleaved.

* Live Demo
  * Here is a live demo of the application: https://interleave.herokuapp.com/
  * The demo is setup with a subset of the datapoints necessary for the Northwestern Prostate SPORE: http://cancer.northwestern.edu/prostatespore/

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
 * bundle exec rake setup:omop_vocabularies
 * bundle exec rake setup:interleave_registries

* Heroku setup
 * heroku create interleave
 * git push heroku master
 * PGUSER=postgres PGPASSWORD=password heroku pg:push interleave_development DATABASE_URL --app interleave
 * https://interleave.herokuapp.com/
