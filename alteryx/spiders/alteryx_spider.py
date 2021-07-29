from alteryx.items import AlteryxItem
from scrapy import Spider, Request
import re, math

class AlteryxSpider(Spider):
    name = 'alteryx_spider'
    allowed_urls = ['https://community.alteryx.com']
    start_urls = ['https://community.alteryx.com/t5/Alteryx-Designer-Discussions/bd-p/designer-discussions']

    def parse(self, response):
        
        top_pb = response.xpath('//ul[@class="lia-paging-full-pages"]')[0]
        number_pages = int(top_pb.xpath('./li/a/text()')[-1].get())
        print(number_pages)

        result_urls = ([f'https://community.alteryx.com/t5/Alteryx-Designer-Discussions/bd-p/designer-discussions/page/{i+1}' for i in range(number_pages)])

        for url in result_urls:
            yield Request(url=url, callback=self.parse_question)

    def parse_question(self, response):

        leftside = response.xpath('//div[@class="lia-quilt-column-alley lia-quilt-column-alley-left"]')
        posts = leftside.xpath('.//div[@class="lia-component-messages-column-message-info"]')

        question_urls = posts.xpath('.//a[@class="page-link lia-link-navigation lia-custom-event"]/@href').extract()
        question_urls = ['https://community.alteryx.com' + i for i in question_urls]

        i = 0
        for url in question_urls:
            yield Request(url=url, meta={'question_urls': question_urls[i]},
                callback=self.parse_question_page_count)
            i += 1

    def parse_question_page_count(self, response):

        post_message = response.xpath('//h2[@class="PageTitle lia-component-common-widget-page-title"]/span/text()').extract_first()
        
        initial_post = response.xpath('//div[@class="first-message lia-forum-linear-view-gte-v5"]')[0]
        
        post_author = initial_post.xpath('.//span[@class="login-bold"]/text()').extract_first()

        post_time = initial_post.xpath('.//span[@class="DateTime"]/span/@title').extract_first()
        if post_time is not None:
            pass
        else:
            post_time = initial_post.xpath('.//span[@class="local-date"]/text()').extract_first()
        post_time = re.search('\d+-\d+-\d+', post_time).group(0)

        reply_count = response.xpath('//div[@class="lia-text lia-forum-topic-page-reply-count lia-discussion-page-sub-section-header lia-component-reply-count-conditional"]/span/text()').extract_first()
        print('\n' + '----' + '\n' + reply_count)
        reply_count = int(reply_count)
        if reply_count <= 10:
            page_count = 1
        else:
            page_count = 1 + math.ceil((reply_count-10)/9)
        print('\n' + '----' + '\n' + str(page_count))

        reply_urls = [response.meta['question_urls'] + '/page' + str(i+1) for i in range(page_count)]

        for url in reply_urls:
            yield Request(
                url=url, 
                meta={'post_message': post_message, 'post_author': post_author, 'post_time': post_time},
                callback=self.parse_question_page
                )

    def parse_question_page(self, response):

        replies = response.xpath('//div[@class="MessageView lia-message-view-forum-message lia-message-view-display lia-row-standard-unread lia-thread-reply"]')
        print('\n' + '=====' + '\n' + str(len(replies)))

        item = AlteryxItem()
        item['post_message'] = response.meta['post_message']
        item['post_author'] = response.meta['post_author']
        item['post_time'] = response.meta['post_time']

        if len(replies) == 0:
            item['reply_author'] = "No replies"
            item['reply_time'] = "No replies"
            yield item
        else:
            for reply in replies:
                try:
                    reply_time = reply.xpath('.//span[@class="DateTime"]/span/@title').extract_first()
                    if reply_time is not None:
                        pass
                    else:
                        reply_time = reply.xpath('.//span[@class="local-date"]/text()').extract_first()
                    reply_time = re.search('\d+-\d+-\d+', reply_time).group(0)
                    item['reply_time'] = reply_time
                except IndexError:
                    item['reply_time'] = "Check"

                item['reply_author'] = reply.xpath('.//span[@class="login-bold"]/text()').extract_first()
                yield item

