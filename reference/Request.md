# Request

A generic Arctos request. Not intended to be used directly. See
InfoRequestBuilder and CatalogRequestBuilder.

## Methods

### Public methods

- [`Request$with_endpoint()`](#method-Request-with_endpoint)

- [`Request$add_param()`](#method-Request-add_param)

- [`Request$add_params()`](#method-Request-add_params)

- [`Request$serialize()`](#method-Request-serialize)

- [`Request$perform()`](#method-Request-perform)

- [`Request$from_raw_response()`](#method-Request-from_raw_response)

- [`Request$clone()`](#method-Request-clone)

------------------------------------------------------------------------

### Method `with_endpoint()`

#### Usage

    Request$with_endpoint(endpoint)

------------------------------------------------------------------------

### Method `add_param()`

#### Usage

    Request$add_param(...)

------------------------------------------------------------------------

### Method `add_params()`

#### Usage

    Request$add_params(l)

------------------------------------------------------------------------

### Method [`serialize()`](https://rdrr.io/r/base/serialize.html)

#### Usage

    Request$serialize()

------------------------------------------------------------------------

### Method `perform()`

#### Usage

    Request$perform(api_key = NULL)

------------------------------------------------------------------------

### Method `from_raw_response()`

#### Usage

    Request$from_raw_response(raw_response)

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Request$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
