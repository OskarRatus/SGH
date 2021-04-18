## app.R ##
library(shiny)
library(shinydashboard)
library(dplyr)
library(RSQLite)
library(ggplot2)
library(purrr)
library(grid)
library(ggthemes)

# # DATA IMPORT
# rm(list = ls())
# 
# # Direct data URL
# # https://www.fs.usda.gov/rds/archive/products/RDS-2013-0009.4/RDS-2013-0009.4_SQLITE.zip
# 
# path <- "C:/users/oskar/Desktop/WIldFire notebooks/FPA_FOD_20170508.sqlite"
# 
# conn <- dbConnect(SQLite(), path)
# fires <- tbl(conn, "Fires") %>% collect()
# dbDisconnect(conn)





# MAIN
header <- dashboardHeader(title = "MyShinyDash")


sidebar <- dashboardSidebar(
    sidebarMenu(
        id = "tabs",
        menuItem(text = "Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem(text = "Charts", tabName = "charts", icon = icon("bar-chart-o"), startExpanded = T,
                 menuSubItem(text = "Number of fires", tabName = "charts1"),
                 menuSubItem(text = "Stability over time", tabName = "charts3"),
                 menuSubItem(text = "Type of", tabName = "charts4"),
                 menuSubItem(text = "USA map", tabName = "charts6"),
                 menuSubItem(text = "State map", tabName = "charts7")
        ),
        menuItem(text = "Citation", tabName = "cite", icon = icon("quote-right"))
    ),
    textOutput("res")
)


body <- dashboardBody(
    tabItems(
        tabItem(tabName = "dashboard", 
                h1("Dashboard stworzony przez ", align = "center"),
                h2("Oskar Ratus", align = "center"),
                h2("Number indeksu - 75279", align = "center")
                
        ),
# 1 SubTab        
        tabItem(tabName = "charts1",
            fluidRow(
                sidebarLayout(
                    position = "left",
                    sidebarPanel(
                        sliderInput(inputId = "year1",
                                    label = "Time span",
                                    min = 1995,
                                    max = 2015,
                                    value = 2015),
                        
                        radioButtons(inputId = "abline1",
                                     label = "Fit model",
                                     choices = c(
                                         "Linear Model" = "lm",
                                         "Generalized Linear Models" = "glm",
                                         "Generalized additive models" = "gam",
                                         "Local Polynomial Regression" = "loess",
                                         "None" = NULL),
                                     selected = c("lm")
                        ),
                        
                        numericInput(inputId = "n_state",
                                     label = "Top n states",
                                     min = 1,
                                     max = 54,
                                     value = 10
                        )
                    ),
                    
                    mainPanel(
    # 1.1
                        box(status = "primary", width = 2/3,
                            plotOutput(outputId = "wykres1_1"),
    # 1.2
                            plotOutput(outputId = "wykres1_2")
                        )
                    )
                )
            )
        ),


# 2 SubTab
        tabItem(tabName = "charts3",
            tabsetPanel(
    # 2.1
                tabPanel(
                    title = "Global overview",
                    fluidRow(
                        sidebarLayout(
                            position = "left",
                            sidebarPanel(
                                sliderInput(
                                    inputId = "year3",
                                    label = "Time span",
                                    max = 2015,
                                    min = 1995,
                                    value = c(1995,2015),
                                    dragRange = T
                                ),
                                checkboxGroupInput(inputId = "stat_list3",
                                                   label = "Choose states: ",
                                                   choiceValues = c(state.abb),
                                                   choiceNames = c(state.name),
                                                   selected = c("CA", "GA", "TX", "NC", "NY")
                                                   
                                )
                            ),
                            mainPanel(
                                box(status = "primary", width = 2/3,
                                    plotOutput(outputId = "wykres2_1")
                                )
                            )
                        )
                    )
                ),
    # 2.2
                tabPanel(
                    title = "Individual overview",
                    fluidRow(
                        sidebarLayout(
                            sidebarPanel(
                                sliderInput(inputId = "year5",
                                            label = "Choose year",
                                            min = 1995,
                                            max = 2015,
                                            value = 2004,
                                            animate = T
                                ),
                                
                                selectInput(
                                    inputId = "state_list5",
                                    label = "Choose state",
                                    choices = c(state.abb),
                                    selected = "TX"
                                ),
                                
                                radioButtons(
                                    inputId = "cause_list5",
                                    label = "Choose cause of fire",
                                    choices = c("Miscellaneous", "Lightning", "Debris Burning", "Campfire", "Equipment Use",  "Arson", "Children", "Railroad",
                                                "Smoking", "Powerline", "Structure", "Fireworks", "Missing/Undefined"
                                    ),
                                    selected = "Miscellaneous"
                                )
                            ),
                            
                            mainPanel(
                                box(status = "primary", width = 2/3,
                                    plotOutput(outputId = "wykres2_2_1"),
                                    plotOutput(outputId = "wykres2_2_2")
                                )
                            )
                        )
                    )
                    
                )
            )
        ),

# 4 SubTab
        tabItem(tabName = "charts4",
            tabsetPanel(
    # 4.1 
                tabPanel(
                    title = "Fire by cause",
                    sidebarLayout(
                        sidebarPanel(
                            checkboxGroupInput(
                                inputId = "cause_list4_1",
                                label = "Cause to choose: ",
                                choices = c("Miscellaneous", "Lightning", "Debris Burning", "Campfire", "Equipment Use",  "Arson", "Children", "Railroad",
                                            "Smoking", "Powerline", "Structure", "Fireworks", "Missing/Undefined"
                                            ), 
                                selected = c("Miscellaneous", "Lightning", "Debris Burning", "Campfire", "Equipment Use",  "Arson", "Children", "Railroad",
                                             "Smoking", "Powerline", "Structure", "Fireworks", "Missing/Undefined"
                                            )
                            )
                        ),
                        mainPanel(
                            box(status = "primary", width = 2/3,
                                plotOutput(outputId = "wykres4_1")
                            )
                        )
                    )
                ),
    # 4.2
                tabPanel(
                    title = "Fire by size",
                    sidebarLayout(
                        sidebarPanel(
                            checkboxGroupInput(
                                inputId = "cause_list4_2",
                                label = "Cause to choose: ",
                                choices = c("Miscellaneous", "Lightning", "Debris Burning", "Campfire", "Equipment Use",  "Arson", "Children", "Railroad",
                                            "Smoking", "Powerline", "Structure", "Fireworks", "Missing/Undefined"
                                ), 
                                selected = c("Miscellaneous", "Lightning", "Debris Burning", "Campfire", "Equipment Use",  "Arson", "Children", "Railroad",
                                             "Smoking", "Powerline", "Structure", "Fireworks", "Missing/Undefined"
                                )
                            )
                        ),
                        mainPanel(
                            box(status = "primary", width = 2/3,
                                plotOutput(outputId = "wykres4_2")
                            )
                        )
                    )
                )
            )
            
        ),

# 6 SubTab
        tabItem(tabName = "charts6",
                sidebarLayout(
                    sidebarPanel(
                        radioButtons(
                            inputId = "cause_list6",
                            label = "Cause to choose",
                            choices = c("Miscellaneous", "Lightning", "Debris Burning", "Campfire", "Equipment Use",  "Arson", "Children", "Railroad",
                                        "Smoking", "Powerline", "Structure", "Fireworks", "Missing/Undefined"
                            ),
                            selected = "Miscellaneous"
                        ),
                        width = 2
                        
                    ),
                    
                    mainPanel(
                        box(status = "primary", width = 2/3,
                            plotOutput(outputId = "wykres6")
                        )
                        
                    )
                )
        ),

# 7 SubTab
        tabItem(tabName = "charts7",
            sidebarLayout(
                sidebarPanel(
                    sliderInput(inputId = "year7",
                                label = "Select year",
                                min = 1992,
                                max = 2015,
                                value = 2004,
                                animate = T
                                
                    ),
                    checkboxGroupInput(inputId = "variable7",
                                       label = "Fire size class",
                                       choices = c(
                                           "Klasa A" = "A",
                                           "Klasa B" = "B",
                                           "Klasa C" = "C",
                                           "Klasa D" = "D",
                                           "klasa E" = "E",
                                           "Klasa F" = "F"),
                                       selected = c("A", "B", "C")
                                       
                    ),
                    
                    selectInput(
                        inputId = "state7",
                        label = "Select state",
                        choices = c(state.abb),
                        selected = "TX"
                    ),
                    width = 2
                ),
                
                mainPanel(
                    box(status = "primary", width = 2/3,
                        plotOutput(outputId = "wykres7")
                    )
                )
            )    
        ),

        tabItem(tabName = "cite",
                fluidRow(
                    box(status = "primary", width = 12,
                        p("Short, Karen C. 2017. Spatial wildfire occurrence data for the United States, 1992-2015 [FPA_FOD_20170508]. 4th Edition. Fort Collins, CO: Forest Service Research Data Archive. https://doi.org/10.2737/RDS-2013-0009.4")
                    )
                    
                    )
            
        )

    )
)



ui <- dashboardPage(header, sidebar, body)


server <- function(input, output) {
    
    output$res <- renderText({
        paste("You've selected:", input$tabs)
    })
    
    
# Wykres 1.1 <- Wildfires by year
    output$wykres1_1 <- renderPlot({
        max <- input$year1
        method <- input$abline1
        
        fires %>% filter(FIRE_YEAR %in% 1992:max) %>% group_by(FIRE_YEAR) %>% count() %>%
            ggplot(aes(x = FIRE_YEAR, y = n)) +
            geom_bar(stat = "identity") +
            geom_smooth(method = method, se = F, colour = "darkred") +
            labs(y = "Total number of fires", x = "Year")
    })

# Wykres 1.2  <- Wildfire by state 
    output$wykres1_2 <- renderPlot({
        n <- input$n_state
        
        fires %>% group_by(STATE) %>% summarise(Number = n())  %>% arrange(desc(Number)) %>% head(n = n) %>%
            ggplot(aes(x = reorder(STATE, Number), y = Number, colour = Number, fill = Number)) +
            geom_bar(stat = "identity", colour = "orange") +
            labs(x = "", y = "Total number of fires by state") +
            coord_flip() +
            scale_fill_continuous(high = "darkred", low = "orange")
    })
    
# Wykres 2.1 <- Wildfire by state by year
    output$wykres2_1 <- renderPlot({
        stat_list <- input$stat_list3
        year3 <- input$year3
        
        fires %>% filter(STATE %in% stat_list) %>% group_by(FIRE_YEAR, STATE) %>% filter(between(FIRE_YEAR, year3[1], year3[2])) %>% summarise(Number = n()) %>% arrange(desc(Number)) %>%
            ggplot(aes(x = FIRE_YEAR, y = Number, group = STATE, colour = STATE, label = STATE)) +
            geom_line() +
            geom_text(size = 4.5) +
            labs(x = "Year", y = "Total number of fires")
    })
    
# Wykres 4.1 <- 
    output$wykres4_1 <- renderPlot({
        cause4_1 <- input$cause_list4_1
        
        fires %>% group_by(STAT_CAUSE_DESCR) %>% filter(STAT_CAUSE_DESCR %in% cause4_1) %>% count() %>% arrange(n) %>%
            ggplot(aes(x = reorder(STAT_CAUSE_DESCR, n), y = n, colour = STAT_CAUSE_DESCR)) +
            geom_bar(stat = "identity", show.legend = F, size = 1.5) +
            labs(y = "Number of fires", x = "") +
            coord_flip() +
            scale_fill_continuous(high = "darkred", low = "orange")
    })
    
# Wykres 4.2 <- Wildfire by fire size
    output$wykres4_2 <- renderPlot({
        cause4_2 <- input$cause_list4_2
        
        fires %>% group_by(STAT_CAUSE_DESCR) %>% filter(STAT_CAUSE_DESCR %in% cause4_2) %>% summarise(mean = mean(FIRE_SIZE)) %>%
            ggplot(aes(x = reorder(STAT_CAUSE_DESCR, mean), y = mean, colour = STAT_CAUSE_DESCR)) +
            geom_bar(stat = "identity", show.legend = F, size = 1.5) +
            labs(x = "", y = "Average size of fire (in acres)") +
            coord_flip()
    })
    

    
# Wykres 2.2.1 <- TEXAS before and after 2004 CAUSE
    output$wykres2_2_1 <- renderPlot({
        state2_2_1 <- input$state_list5
        year2_2_1 <- input$year5
        
    # Additional data set up
        TX_bot <- fires %>% filter(STATE %in% state2_2_1) %>% filter(FIRE_YEAR <= year2_2_1) %>% group_by(STAT_CAUSE_DESCR) %>% count()
        TX_bot$year <- "BEFORE"
        TX_top <- fires %>% filter(STATE %in% state2_2_1) %>% filter(FIRE_YEAR > year2_2_1) %>% group_by(STAT_CAUSE_DESCR) %>% count()
        TX_top$year <- "AFTER"
        TX_all <- bind_rows(TX_bot, TX_top)
        
        TX_all %>%
            ggplot(aes(x = reorder(year, year), y = n, fill = reorder(STAT_CAUSE_DESCR, -n))) +
            geom_bar(position = "fill", stat = "identity", colour = 'black') +
            labs(x = "", y = "", fill = "Legenda")
        
    })

# Wykres 2.2.1
    output$wykres2_2_2 <- renderPlot({
        state2_2_2 <- input$state_list5
        cause2_2_2 <- input$cause_list5
        
        test <- fires %>% filter(STATE %in% state2_2_2) %>% group_by(FIRE_YEAR) %>% count()
        test2 <-  fires %>% filter(STATE %in% state2_2_2) %>% filter(STAT_CAUSE_DESCR %in% cause2_2_2) %>% group_by(FIRE_YEAR) %>% count()
        
        ggplot() +
            geom_line(aes(x = FIRE_YEAR, y = n), data = test2, size = 1.5, colour = "darkred") + # Miscellaneous
            geom_line(aes(x = FIRE_YEAR, y = n), data = test) +              # All
            labs(x = "", y = "Total number of fires / Number of fires by selected cause")
        
    })
    
    
    # Additional data set up
    state.abb <- union(state.abb, c("DC", "PR"))
    state.name <- union(state.name, c("District of Columbia", "Puerto Rico"))
    fires$region <- map_chr(fires$STATE, function(x) { tolower(state.name[grep(x, state.abb)]) })
    state_map <- map_data('state')
    
    
# Wykres 6 <- "Miscellaneous" fires by state
    output$wykres6 <- renderPlot({
        cause6 <- input$cause_list6
        
        
        fires %>% group_by(region) %>% filter(STAT_CAUSE_DESCR %in% cause6) %>% count() %>% right_join(state_map, by = "region") %>%
            ggplot(aes(x = long, y = lat, group = group, fill = n)) +
            geom_polygon() +
            scale_fill_continuous(high = "darkred", low = "orange", name = "Number of fires by cause") +
            geom_path(color = "white") +
            labs(x = "",  y = "") +
            theme_map() +
            theme(aspect.ratio = 1/2)
    })
    
    
# Wykres 6.2 <- Teksas by Class by Year
    output$wykres7 <- renderPlot({
        fYearTX <- input$year7
        fSizeTX <- input$variable7
        state_lower <- tolower(state.name[grep(input$state7, state.abb)])
        state_abb <- input$state7
        
        state_map %>% filter(region %in% state_lower) %>%
            ggplot(aes(x = long, y = lat)) +
            geom_polygon(fill = "orange") +
            geom_point(aes(x = LONGITUDE, y = LATITUDE), data = fires %>% filter(STATE %in% state_abb) %>% filter(FIRE_YEAR %in% fYearTX) %>% filter(FIRE_SIZE_CLASS %in% fSizeTX), colour = "darkred") +
            geom_path(color = "white") +
            theme_map() +
            ggtitle(state.name[grep(input$state7, state.abb)]) +
            theme(plot.title = element_text(size=35, hjust = 0.5), aspect.ratio = 1)
    })
    
    
}

shinyApp(ui, server)

