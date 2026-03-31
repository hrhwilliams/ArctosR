# CatalogRequestBuilder

CatalogRequestBuilder

CatalogRequestBuilder

## Super class

[`ArctosR::RequestBuilder`](https://hrhwilliams.github.io/ArctosR/reference/RequestBuilder.md)
-\> `CatalogRequestBuilder`

## Methods

### Public methods

- [`CatalogRequestBuilder$set_limit()`](#method-CatalogRequestBuilder-set_limit)

- [`CatalogRequestBuilder$set_query()`](#method-CatalogRequestBuilder-set_query)

- [`CatalogRequestBuilder$set_filter()`](#method-CatalogRequestBuilder-set_filter)

- [`CatalogRequestBuilder$set_parts()`](#method-CatalogRequestBuilder-set_parts)

- [`CatalogRequestBuilder$set_attributes()`](#method-CatalogRequestBuilder-set_attributes)

- [`CatalogRequestBuilder$set_components()`](#method-CatalogRequestBuilder-set_components)

- [`CatalogRequestBuilder$set_columns()`](#method-CatalogRequestBuilder-set_columns)

- [`CatalogRequestBuilder$set_columns_list()`](#method-CatalogRequestBuilder-set_columns_list)

- [`CatalogRequestBuilder$from_previous_response()`](#method-CatalogRequestBuilder-from_previous_response)

- [`CatalogRequestBuilder$build_request()`](#method-CatalogRequestBuilder-build_request)

- [`CatalogRequestBuilder$clone()`](#method-CatalogRequestBuilder-clone)

Inherited methods

- [`ArctosR::RequestBuilder$debug()`](https://hrhwilliams.github.io/ArctosR/reference/RequestBuilder.html#method-debug)

------------------------------------------------------------------------

### Method `set_limit()`

Sets the limit on how many records to initially request from Arctos.

#### Usage

    CatalogRequestBuilder$set_limit(limit)

#### Arguments

- `limit`:

  (`integer(1)`).

#### Returns

CatalogRequestBuilder.

------------------------------------------------------------------------

### Method `set_query()`

Sets the query parameters to use to search Arctos.

#### Usage

    CatalogRequestBuilder$set_query(...)

#### Arguments

- `query`:

  (`list`).

#### Returns

CatalogRequestBuilder.

------------------------------------------------------------------------

### Method `set_filter()`

Sets the result parameters to use to filter out results.

#### Usage

    CatalogRequestBuilder$set_filter(...)

#### Arguments

- `query`:

  (`list`).

#### Returns

CatalogRequestBuilder.

------------------------------------------------------------------------

### Method `set_parts()`

Set parts to query over.

#### Usage

    CatalogRequestBuilder$set_parts(...)

#### Arguments

- `parts`:

  (`list`).

#### Returns

CatalogRequestBuilder.

------------------------------------------------------------------------

### Method `set_attributes()`

Set attributes to query over.

#### Usage

    CatalogRequestBuilder$set_attributes(...)

#### Arguments

- `attributes`:

  (`list`).

#### Returns

CatalogRequestBuilder.

------------------------------------------------------------------------

### Method `set_components()`

Set components to query over.

#### Usage

    CatalogRequestBuilder$set_components(...)

#### Arguments

- `components`:

  (`list`).

#### Returns

CatalogRequestBuilder.

------------------------------------------------------------------------

### Method `set_columns()`

Sets the columns in the dataframe returned by Arctos.

#### Usage

    CatalogRequestBuilder$set_columns(...)

#### Arguments

- `cols`:

  (`list`).

#### Returns

CatalogRequestBuilder.

------------------------------------------------------------------------

### Method `set_columns_list()`

Sets the columns in the dataframe returned by Arctos.

#### Usage

    CatalogRequestBuilder$set_columns_list(l)

#### Arguments

- `cols`:

  (`list`).

#### Returns

CatalogRequestBuilder.

------------------------------------------------------------------------

### Method `from_previous_response()`

Sets the columns in the dataframe returned by Arctos.

#### Usage

    CatalogRequestBuilder$from_previous_response(response)

#### Arguments

- `response`:

  a response object from a previous request

#### Returns

[FromResponseRequestBuilder](https://hrhwilliams.github.io/ArctosR/reference/FromResponseRequestBuilder.md).

------------------------------------------------------------------------

### Method `build_request()`

Send a request for data to Arctos with parameters specified by the other
methods called on this class.

#### Usage

    CatalogRequestBuilder$build_request()

#### Returns

[Response](https://hrhwilliams.github.io/ArctosR/reference/Response.md).

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    CatalogRequestBuilder$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
