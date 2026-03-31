# FromResponseRequestBuilder

Builder for the case where a request is made with the context of a
previous response.

## Super class

[`ArctosR::RequestBuilder`](https://hrhwilliams.github.io/ArctosR/reference/RequestBuilder.md)
-\> `FromResponseRequestBuilder`

## Methods

### Public methods

- [`FromResponseRequestBuilder$new()`](#method-FromResponseRequestBuilder-new)

- [`FromResponseRequestBuilder$request_more()`](#method-FromResponseRequestBuilder-request_more)

- [`FromResponseRequestBuilder$build_request()`](#method-FromResponseRequestBuilder-build_request)

- [`FromResponseRequestBuilder$clone()`](#method-FromResponseRequestBuilder-clone)

Inherited methods

- [`ArctosR::RequestBuilder$debug()`](https://hrhwilliams.github.io/ArctosR/reference/RequestBuilder.html#method-debug)

------------------------------------------------------------------------

### Method `new()`

#### Usage

    FromResponseRequestBuilder$new(response, records)

------------------------------------------------------------------------

### Method `request_more()`

Request at most `count` more records from this response's original query

#### Usage

    FromResponseRequestBuilder$request_more(count)

#### Arguments

- `count`:

  number of additional records to request

#### Returns

FromResponseRequestBuilder

------------------------------------------------------------------------

### Method `build_request()`

Perform the request.

#### Usage

    FromResponseRequestBuilder$build_request()

#### Returns

Request

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    FromResponseRequestBuilder$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
