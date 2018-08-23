# -*- coding: utf-8 -*-

import logging
from icrawler.builtin import BingImageCrawler,GoogleImageCrawler
from urllib.request import urlopen
import re

MAX_DOWNLOAD_NUMBER = 1000
SEARCH_TYPE = ' leaf'

# get tree type name


list_of_tree_type = []

for i in range(1, 11):
    if i == 1:
        page_number = ''
    else:
        page_number = i

    url = "http://www.allcreativedesigns.com.au/pages/galltrees" + str(page_number) + '.html'
    html = urlopen(url).read().decode('cp1252')

    tree_type = re.findall(r"<h5>(.+?)</h5>", html)
    # get tree type
    for each_tree_type in tree_type:
        final_tree_type = re.sub(r'<em>|</em>|&nbsp;', "", each_tree_type)
        list_of_tree_type.append(final_tree_type)



# download image


def run_google(search_keyword):

    google_crawler = GoogleImageCrawler(
        feeder_threads=1,
        parser_threads=2,
        downloader_threads=4,
        storage={'root_dir': 'images/Training Data/{}'.format(search_keyword)})

    google_crawler.crawl(keyword= search_keyword + SEARCH_TYPE,  max_num=MAX_DOWNLOAD_NUMBER, file_idx_offset=0)

def run_bing(search_keyword):
    print('start BingImageCrawler')
    bing_crawler = BingImageCrawler(
        feeder_threads=1,
        parser_threads=2,
        downloader_threads=4,
        storage={'root_dir': 'images/Training Data/{}'.format(search_keyword)},
        log_level=logging.INFO)

    bing_crawler.crawl(keyword= search_keyword + SEARCH_TYPE, max_num=MAX_DOWNLOAD_NUMBER)

# image process





def main():

    for each_tree in list_of_tree_type:
        run_bing(each_tree)

    print("We have find " + str(len(list_of_tree_type)) + "type of Tree In Australia")


if __name__ == '__main__':
    main()