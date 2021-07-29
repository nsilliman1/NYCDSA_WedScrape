
shinyUI(
  dashboardPage(
    dashboardHeader(title = "Alteryx Community Activity"), 
    dashboardSidebar(
      sidebarUserPanel("Navigation"), 
      sidebarMenu(
        menuItem("Home", tabName = "home"),
        menuItem("Community Activity", tabName = "activity"),
        menuItem("Forum Topics (in progress)", tabName = "forums"),
        menuItem("Dataset", tabName = "dataset")
      )
    ),
    dashboardBody(
      tabItems(
         tabItem(tabName = "home",
            fluidRow(
              tabBox(
                id = "tabset1",
                tabPanel("Analysis Rational", 
                         h4("Web Scrap of Alteryx Community to Gauge User Engagement"),
                         h5("The rational for this project is to examine activity on Alteryx Community forum page and 
                            look at that in relation to the stock price."),
                         h5("See the next tab for more details on the data used."),
                         h5("The sidebar provides navigation to the Analysis. I have provided a 'Community Activity' tab in which
                            I detail certain metrics of the forum activity along with the trended stock price. The Forum Topics
                            page looks at the words used in the posts and looks how words related to predictive analytics
                            have evolved over time, as that is a focus of Alteryx growth.")
                ),
                tabPanel("Alteryx",
                         h5("Alteryx, Inc. provides end-to-end analytics platform for data analysts and scientists worldwide. Its 
                            analytic process automation software platform includes Alteryx Designer, a data profiling, 
                            preparation, blending, and analytics product used to create visual workflows or analytic processes."),
                         h6("Re: Yahoo Finance"),
                         h5("Recently, Alteryx has made an effort to offer more 'predictive' analytics offerings to compete
                            with open source tools and to expand its analytic offerings.")
                ),
                tabPanel("Data",
                         h4("Alteryx Community Forum Posts"),
                         h5("This data was scraped from Alterxy's Community website. On this site the encourage discussion of the 
                            platform and is a place where users can ask questions and also suggest improvements"),
                         h5("https://community.alteryx.com/t5/Alteryx-Designer-Discussions/bd-p/designer-discussions"),
                         h5("The scraping procedure cycled through all the above pages (as of 7-10-2021), all posts within each page,
                            and all replies within each post. The scraping procedure grabbed the initial post message topic, time,
                            and author. It additionally grabbed the reply post time and author related to each initial post. The 
                            posts data was filtered to include full months (for aggregation purposes) from 06-01-2016 to 07-01-2021"),
                         h4("Alteryx Stock Price"),
                         h5("This data was sourced from an API (tidyquant). Alteryx went public on 03-24-2017 and I include stock price 
                            data to 07-01-2021.")
                )
              )
            )
         ),
         tabItem(tabName = "activity", 
            fluidRow(
              box(title = "Alteryx Stock Price (Average Monthly Closing Price)", status = 'warning', solidHeader = TRUE,
                  plotOutput("activity1")),
              box(title = "Number of Unique Initial Posts by Month", status = 'warning', solidHeader = TRUE,
                  plotOutput("activity2"))
            ),
            fluidRow(
              box(title = "Number of Initial Posts and Replies by Month", status = 'warning', solidHeader = TRUE,
                  plotOutput("activity3")),
              box(title = "Monthly Cumulative Count of Unique Users", status = 'warning', solidHeader = TRUE,
                  plotOutput("activity4")),
            ),
            fluidRow("Alteryx's stock price has seen significant growth from 2017 through 2020, although has stalled as of late.
                     Much of Alteryx's valuation is based around a high growth assumption. I attempt to get an indication
                     of that 'growth assumption' by exploring these user engagemnet metrics on the Alteryx Community. By looking
                     at the graphs, one could make an argument that there user engagement is starting to stall."
            )
         ),
        tabItem(tabName = "forums",
                fluidRow(
                  box("In future iterations, I will want to do a text mining analysis on initial post topic.
                      Alteryx is trying to grow their predictive offerings, so I would want to examine the 
                      share of words over time that are related to 'predictive'/'modeling' concepts."
                     )
                  )
        ),
        tabItem(tabName = "dataset", DT::dataTableOutput("table"))
      )
    )
  )
)
  