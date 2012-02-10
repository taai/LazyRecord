LazyRecord
==========

Command-line Usage
------------------
Create a config skeleton:

    $ lazy init-conf

Then build config:

    $ lazy build-conf path/to/config.yml

Define your model schema, note: the schema file name must be with suffix "Schema".

    $ vim src/App/Model/AuthorSchema.php

    class AuthorSchema extends SchemaDeclare
    {
        function schema()
        {
            $this->column('id')
                ->type('integer')
                ->isa('int')
                ->primary()
                ->autoIncrement();

            $this->column('name')
                ->isa('str')
                ->varchar(128);

            $this->column('email')
                ->isa('str')
                ->required()
                ->varchar(128);

            $this->column('confirmed')
                ->isa('bool')
                ->default(false)
                ->boolean();
        }
    }

To generate SQL schema:

    lazy build-schema path/to/AuthorSchema.php

Then you should have these files:

    src/App/Model/AuthorSchema.php
    src/App/Model/AuthorBase.php
    src/App/Model/Author.php
    src/App/Model/AuthorBaseCollection.php
    src/App/Model/AuthorCollection.php

To import SQL schema into database:

    lazy build-sql path/to/AuthorSchema.php

    lazy build-sql path/to/schema/

LazyRecord will generate schema in pure-php array, in-place

    path/schema/AuthorSchemaProxy.php
    path/schema/AuthorBase.php           // auto-generated AuthoBase 
    path/schema/Author.php               // customizeable

    path/schema/AuthorCollectionBase.php // auto-generated AuthorCollection extends AuthorCollectionBase {  }
    path/schema/AuthorCollection.php     // customizable

    path/schema/foo/bar/BookBase.php
    path/schema/foo/bar/Book.php

    path/schema/foo/bar/BookCollection.php
    path/schema/foo/bar/BookSchemaProxy.php

    path/classmap.php        // application can load Model, Schema class from this mapping file
    path/datasource.php      // export datasource config

### Connecting the dots

Initialize loader:

    $lazyLoader = new ConfigLoader;
    $lazyLoader->load( 'path/to/config.php' );   // this initialize data source into connection manager.

To setup QueryDriver:
 
    $driver = Lazy\QueryDriver::getInstance('data_source_id');
    $driver->configure('driver','pgsql');
    $driver->configure('quote_column',true);
    $driver->configure('quote_table',true);

To create a model record:

    $author = new Author;
    $author->create(array(
        'name' => 'Foo'
    ));

    Author::load( ... );

To create a collection object:

    $authors = new Collection;
    $authors->where()
        ->equal( 'id' , 'foo' );

To get PDO connection:

    $pdo = \LazyRecord\ConnectionManager::getInstance()->getConnection('default');


