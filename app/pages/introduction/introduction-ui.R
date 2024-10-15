sidebarLayout(
  sidebarPanel(width = 4,
               radioGroupButtons("home_select", status = "home",
                                 choices = home_list,
                                 direction = "vertical", justified = T)),
  
  mainPanel(width = 8,
            # About
            conditionalPanel(
              condition= "input.home_select == 'About'",
              # These have to be uiOutputs rather than just tagLists because otherwise
              # the ui loads before the conditional panel hides the info so for some
              # time at the beginning of the app all of the panels are visible
              withNavySpinner(uiOutput("introduction_about"), navy)
            ), # conditionalPanel
            
            # Using the dashboard
            conditionalPanel(
              condition= "input.home_select == 'Use'",
              withNavySpinner(uiOutput("introduction_use"), navy)
            ), # condtionalPanel
            
            # Further information
            conditionalPanel(
              condition= "input.home_select == 'Contact'",
              withNavySpinner(uiOutput("introduction_contact"), navy)
            ), # conditionalPanel
            
            # Accessibility
            conditionalPanel(
              condition= "input.home_select == 'Accessibility'",
              withNavySpinner(uiOutput("introduction_accessibility"), navy)
            )
  ) # mainPanel
) # sidebarLayout

