# -*- coding: utf-8 -*-

import logging
from icrawler.builtin import BingImageCrawler,GoogleImageCrawler
from urllib.request import Request, urlopen
import re
from bs4 import BeautifulSoup
from PIL import Image
from resizeimage import resizeimage
# open file
import os

MAX_DOWNLOAD_NUMBER = 1000
SEARCH_TYPE = ' tree'
ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
# get tree type name


list_of_tree_type = []

req = Request("http://www.johnfrenchlandscapes.com.au/common-trees-in-melbourne/", headers={'User-Agent': 'Mozilla/5.0'})
html = urlopen(req).read()
soup = BeautifulSoup(html,features='lxml')

# # get tree type
type = soup.find('div',attrs={"class":"post-box"}).findAll('p')
for all_p in type:
    if all_p.find('strong') != None:
        list_of_tree_type.append(all_p.find('strong').text)





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
def image_process():
    path = os.path.join(ROOT_DIR, 'images/Training Data')
    dictionarys= os.listdir(path)

    for each_folder in dictionarys:
        if not os.path.isdir(each_folder) and each_folder in list_of_tree_type:
            # list all tree pic in a folder
            tree_pics = os.listdir(path + "/" + each_folder)
            for each_pic in tree_pics:
                pic_path = path + "/" + each_folder + '/' + each_pic
                with open(pic_path, 'r+b') as pic:
                    with Image.open(pic) as image:
                        try:
                            cover = resizeimage.resize_cover(image, [250, 250])
                            cover.save(pic_path, image.format)
                        except:
                            print('size incorract')
                            continue



def main():

    for each_tree in list_of_tree_type:
        run_bing(each_tree)

    # image process
    image_process()
    print("We have find " + str(len(list_of_tree_type)) + " type of Tree In Australia")


if __name__ == '__main__':
    main()