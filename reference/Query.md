# Query

The results of a user query. Able to accept multiple responses to
increase the record count, or to add columns.

## Methods

### Public methods

- [`Query$catalog_request()`](#method-Query-catalog_request)

- [`Query$from_response_request()`](#method-Query-from_response_request)

- [`Query$info_request()`](#method-Query-info_request)

- [`Query$perform()`](#method-Query-perform)

- [`Query$save_metadata_json()`](#method-Query-save_metadata_json)

- [`Query$save_records_csv()`](#method-Query-save_records_csv)

- [`Query$expand_col()`](#method-Query-expand_col)

- [`Query$get_responses()`](#method-Query-get_responses)

- [`Query$clone()`](#method-Query-clone)

------------------------------------------------------------------------

### Method `catalog_request()`

#### Usage

    Query$catalog_request()

------------------------------------------------------------------------

### Method `from_response_request()`

#### Usage

    Query$from_response_request()

------------------------------------------------------------------------

### Method `info_request()`

#### Usage

    Query$info_request()

------------------------------------------------------------------------

### Method `perform()`

#### Usage

    Query$perform(api_key = NULL)

------------------------------------------------------------------------

### Method `save_metadata_json()`

#### Usage

    Query$save_metadata_json(file_path)

------------------------------------------------------------------------

### Method `save_records_csv()`

#### Usage

    Query$save_records_csv(file_path, expanded = FALSE)

------------------------------------------------------------------------

### Method `expand_col()`

#### Usage

    Query$expand_col(column_name)

------------------------------------------------------------------------

### Method `get_responses()`

#### Usage

    Query$get_responses()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Query$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
