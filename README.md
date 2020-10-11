# Ouverture

> *ouverture* /uvɛʀtyʀ/ nf. opening

`Ouverture` is a macOS utility aiming to facilitate the process of inspecting and modifying the default handlers of file types and URL schemes.

Warning: This project is still in its early days. Use it with care!

## Contents

- [Ouverture](#ouverture)
  - [Contents](#contents)
  - [Usage By Example](#usage-by-example)
    - [Set default handler: `ovt bind`](#set-default-handler-ovt-bind)
    - [Check file/URL support: `ovt check`](#check-fileurl-support-ovt-check)
    - [Get bundle ID: `ovt id`](#get-bundle-id-ovt-id)
    - [Look up file/URL claimer(s): `ovt lookup`](#look-up-fileurl-claimers-ovt-lookup)
    - [Get app path: `ovt which`](#get-app-path-ovt-which)
    - [UTI utilities: `ovt uti`](#uti-utilities-ovt-uti)

## Usage By Example

The use of this project is mainly around `UTI`s ([what's this?](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_conc/understand_utis_conc.html)) and URL Schemes.
You can find a complete list of UTIs [here](https://escapetech.eu/manuals/qdrop/uti.html), and a list of URL schemes [here](https://en.wikipedia.org/wiki/List_of_URI_schemes).

### Set default handler: `ovt bind`

- Set default handler by bundle path:

    ```bash
    # URL schemes end with `://`
    ovt bind path /Applications/Safari.app/ http://

    # UTIs are reverse domain names
    ovt bind path /Applications/Safari.app/ com.adobe.pdf

    # Extensions start with a `.`
    ovt bind path /Applications/Safari.app/ .pdf

    # ... or you can simply omit the `.`
    ovt bind path /Applications/Safari.app/

    # `path` can also be omitted here
    ovt bind /Applications/Safari.app/ pdf
    ```

- Set default handler by bundle ID:

    ```bash
    # See above, just use `ovt bind id` this time
    ovt bind id com.apple.Safari http://
    ```

### Check file/URL support: `ovt check`

Find all the file types or URL schemes supported by an app bundle.

- Check support by bundle path:

    ```bash
    ovt check path /Applications/IINA.app # => File Extensions: 3g2, 3gp, aa3, aac, ...

    # `path` can be omitted here
    ovt check /Applications/IINA.app/
    ```

- Check support by bundle ID:

    ```bash
    # See above, just use `ovt check id` this time
    ovt check id com.apple.Safari # => File Extensions: css, download, gif, ...
    ```

### Get bundle ID: `ovt id`

```bash
ovt id /Applications/Safari.app/ # => com.apple.Safari
```

### Look up file/URL claimer(s): `ovt lookup`

Find all the app bundles which have claimed some file type or URL scheme.

```bash
# URL schemes end with `://`
ovt lookup http:// # => com.apple.Safari, ...

# UTIs are reverse domain names
ovt lookup com.adobe.pdf # => com.apple.Preview, ...

# Extensions start with a `.`
ovt lookup .pdf # => com.apple.Preview, ...

# ... or you can simply omit the `.`
ovt lookup pdf # => com.apple.Preview, ...
```

### Get app path: `ovt which`

```bash
# This will return a list of all possible paths
ovt which com.apple.Safari

# Use `--lucky` if you want the first one only
ovt which com.apple.Safari --lucky # => /Applications/Safari.app
```

### UTI utilities: `ovt uti`

- Get the UTI of a file extension:

  ```bash
  ovt uti from-ext .pdf # => com.adobe.pdp

  # ... or you can simply omit the `.`
  ovt uti from-ext pdf # => com.adobe.pdf
  ```

- Get the possible extension(s) of a UTI:

  ```bash
  ovt uti to-ext public.mpeg-4 # => mp4, mpeg4

  # Use `--lucky` if you want the first one only
  ovt uti to-ext public.mpeg-4 --lucky # => mp4
  ```

- Get the parent(s) of a UTI:

  ```bash
  ovt uti parent public.mpeg-4 # => public.movie
  ```

- Get the description string of a UTI:

  ```bash
  # This might not work on some machines
  ovt uti describe public.mpeg-4 # => MPEG-4 movie
  ```
