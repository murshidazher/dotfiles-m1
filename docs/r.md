# R Setup

> Don't install r from brew because of binary issues, set it up using this [article](https://ryanhomer.github.io/posts/build-openmp-macos-catalina-complete#install-r-studio)

- It is possible to get X11-related warnings or erros when installing packages or loading other R libraries. If at any point you need to install X11,

```sh
> brew cask install xquartz
```

## Initial R packages

> Installed R packages are at `‘/usr/local/Cellar/r/4.0.3_2/lib/R/library/DT’`

```sh
> install.packages("devtools")
> library(devtools)
> devtools::install_github("rstudio/reticulate")
> devtools::install_github("rstudio/tensorflow")
> library(tensorflow)
> install_tensorflow()
```
