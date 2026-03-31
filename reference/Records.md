# Records

A (possibly nested) data frame of records returned by a static set of
query and result parameters

## Methods

### Public methods

- [`Records$new()`](#method-Records-new)

- [`Records$append()`](#method-Records-append)

- [`Records$save_flat_csv()`](#method-Records-save_flat_csv)

- [`Records$save_nested_csvs()`](#method-Records-save_nested_csvs)

- [`Records$expand_col()`](#method-Records-expand_col)

- [`Records$clone()`](#method-Records-clone)

------------------------------------------------------------------------

### Method `new()`

#### Usage

    Records$new(df, tbl)

------------------------------------------------------------------------

### Method [`append()`](https://rdrr.io/r/base/append.html)

#### Usage

    Records$append(other)

------------------------------------------------------------------------

### Method `save_flat_csv()`

Writes the data in the response object to a CSV file.

#### Usage

    Records$save_flat_csv(file_path)

------------------------------------------------------------------------

### Method `save_nested_csvs()`

#### Usage

    Records$save_nested_csvs(file_path)

------------------------------------------------------------------------

### Method `expand_col()`

Expand a column of nested JSON tables in the response to a list of
dataframes.

#### Usage

    Records$expand_col(column)

#### Arguments

- `col`:

  (`string`)

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Records$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
