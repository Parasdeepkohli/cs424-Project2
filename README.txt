# cs424-Project2

ShinyAPP link:  https://parasdeepkohli.shinyapps.io/Project-2/
Github link: https://github.com/Parasdeepkohli/cs424-Project2

I highly recommend using Rstudio as your IDE for this application

Once you get Rstudio installed, please install the following libraries using the 'install.packages("<library name>"):

- Shiny
- leaflet


Steps to link this application to your Shiny account:

1. Open Rstudio
2. Set your working directory to the Shiny App folder with "setwd("<path>") NOTE: '\' is an escape character
3. Ensure you have the required libraries installed
4. Open either "server.R" or "ui.R" in Rstudio using "File -> Open File" on the top left
5. Click the "run app" option next to a green horizontal arrow on the top right NOTE: If you don't, try updating Rstudio
6. Once you have ensured that everything is functional, click the "publish" icon on the top-right, next to the "run app" option

You'll need to link your Shiny account to Rstudio before publishing. The steps to do that are:

1. Open Rstudio
2. Go to "Tools -> Global options"
3. In the "publishing" tab, select "connect"

In case you do not have an account, please visit "Shinyapps.io" and create one before following the above steps


Credits for code snippets (Only needed minor modifications to fit my solution. These guys are awesome!):

- Select all feature by user 'yihui' at https://github.com/rstudio/shiny/issues/42