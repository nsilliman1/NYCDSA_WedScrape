
shinyServer(function(input, output){
    output$table <- DT::renderDataTable({
        datatable(posts, rownames = FALSE, options = list(scrollX = TRUE), width = 50) %>%
        formatStyle(input$selected,
            background="skyblue", fontWeight='bold')
    })
    output$activity1 <- renderPlot(
      ayx %>% group_by(date_month) %>% summarise(mean = mean(AYX.Close)) %>% 
        ggplot(aes(x = date_month, y = mean)) +
          geom_line() +
          geom_point() +
          theme_bw() +
          ylab("Daily Price") +
          xlab("Month") +
          xlim(start, end)
    )
    output$activity2 <- renderPlot(
      posts %>% group_by(post_month, post_message) %>% 
        summarise(n = n()) %>% 
        group_by(post_month) %>% 
        summarise(n = n()) %>% 
          ggplot(aes(x = post_month, y = n)) +
            geom_line() +
            geom_point() +
            ylab("Intital Posts") +
            xlab("Month") +
            theme_bw()
    )
    output$activity3 <- renderPlot(
      posts %>% mutate(reply_month = as.Date(ifelse(is.na(reply_month), post_month, reply_month))) %>% 
        group_by(reply_month) %>% 
        summarise(n = n()) %>% 
          ggplot(aes(x = reply_month, y = n)) +
            geom_line() +
            geom_point() +
            ylab("All Posts") +
            xlab("Month") +
            theme_bw()
    )
    output$activity4 <- renderPlot(
      users %>% 
        ggplot(aes(x = min_time2_month, y = cumsum)) +
          geom_line() +
          geom_point() +
          ylab("Cumulative Unique Users") +
          xlab("Month") +
          theme_bw()
    )
    output$explore <- renderPlot(
      music_df_sum %>%
        ggplot(
          aes(
            x = eval(parse(text = paste0('music_df_sum','$',as.character(input$xaxis)))),
            y = eval(parse(text = paste0('music_df_sum','$',as.character(input$yaxis))))
          )) +
          geom_point(aes(size = 3, fill = year_bin), pch = 21, color = 'black') +
          xlab(as.character(input$xaxis)) +
          ylab(as.character(input$yaxis)) +
          theme_bw() +
          guides(size = FALSE) +
          theme(legend.title = element_text(size=14, face="bold")) +
          guides(fill = guide_legend(override.aes = list(size = 6))) +
          scale_fill_discrete(name = "Decade") +
          scale_fill_brewer(palette="PiYG")
    )
})
