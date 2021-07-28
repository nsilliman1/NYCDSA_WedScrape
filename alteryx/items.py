# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy

class AlteryxItem(scrapy.Item):
    post_message = scrapy.Field()
    post_author = scrapy.Field()
    post_time = scrapy.Field()
    reply_author = scrapy.Field()
    reply_time = scrapy.Field()
