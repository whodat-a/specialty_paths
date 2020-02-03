
# coding: utf-8

# Import the libraries we will be using. Right now that is beautiful soup.

# In[89]:

from bs4 import BeautifulSoup
import urllib
import json


# Grab the website

# In[90]:

nrmp_page = urllib.urlopen("http://www.nrmp.org/participating-fellowships/").read()
nrmp_soup = BeautifulSoup(nrmp_page)
print type(nrmp_soup)


# In[91]:

print nrmp_soup.prettify()[0:1000]


# I searched on the NRMP page for the parent class that encompases all of the fellowships. This had the class `main-box`.

# In[92]:

nrmp_soup.find_all(class_="main-box")


# All of the fellowships have "span" tags and the class "title" so we make a little for-loop that will print out the text of each span within the "main-box" class if it has a tag of "span"

# In[93]:

for title in nrmp_soup.find_all(class_="main-box"):
    title_descendants = title.descendants
    for d in title_descendants:
        if d.name == "span":
            print d.text


# The goal is to get the data into a format that D3 understands, which is json. The way the json looks is a dictionary with list of dictionaries, which looks like the following for the nodes:
# 
# `{"nodes":[{"name":'Abdominal Transplant Surgery Match'},...`
# 
# I also had to convert the text to utf8 and then to string to get rid of the 'u' that was accompanying the text 
# 
# `str(d.text.encode('utf8'))`

# In[94]:

nodes = []
temp_dict = {}
for title in nrmp_soup.find_all(class_="main-box"):
    title_descendants = title.descendants
    for d in title_descendants:
        if d.name == "span":
            temp_dict["name"] = str(d.text.encode('utf8')).replace(' \xe2\x80\x93 ', ' ').replace(' / ', '/')
            nodes.append(temp_dict.copy())


# In[95]:

nodes


# There are 29 felloships listed. I don't want to go each by hand and extract the pertinent information. Luckily, the page structure is consistent throughout:
# 
# `http://www.nrmp.org/fellowships/[name of fellowhip]/`
# 
# for example: http://www.nrmp.org/fellowships/adolescent-medicine-match/
# 
# Luckily, we can just pull the `href` text betwen the `a` tags to get a list of links, like so:

# ### Get list of links for fellowship details

# In[96]:

# fellowships_lol = [name.values() for name in nodes] # returns list of lists
# fellowships = [name for sublist in fellowships_lol for name in sublist] # flattens list of lists
# fellowships

fellowship_links = []
for title in nrmp_soup.find_all(class_="main-box"):
    for a in title.find_all('a', href=True):
        fellowship_links.append(a['href'])
print fellowship_links


# ### Test script for pulling details from fellowship page

# In[97]:

adolescent_med = urllib.urlopen("http://www.nrmp.org/fellowships/adolescent-medicine-match/").read()
adolescent_med_soup = BeautifulSoup(adolescent_med)


# ### Pull relevant information
# 
# This step is a bit mor involved. Here's what we want to do:
# 
# 1. Go to each page in the list
# 2. Pull residency that must be completed
# 3. Add the residency that must be completed to the list of nodes
# 4. Convert `nodes` from list to dict with `nodes = dict({"nodes": nodes})`

# In[98]:

adolescent_med_soup.prettify()[0:1000] #inspect


# In[86]:

# for chunk in adolescent_med_soup.find_all(class_="match-row"):
#     residency = str(chunk.find("li").string).split('in ')[1:]
#     residency_text = ', '.join(residency)
#     residency_list = residency_text.split(', ')


# In[99]:

import re
for chunk in adolescent_med_soup.find_all(class_="match-row"):
    residency = str(chunk.find("li").string).split('in ')[1:]
    residency_text = ', '.join(residency)
    residency_list = residency_text.split(', ')
    pattern = re.compile("(or)\W", re.I)
    residency_list = map(lambda residency: pattern.sub("", residency),  residency_list)
    
print residency_list


# Now that we have a clean list of residencies, we need to put them in the right json format like we did the fellowships:

# In[101]:

temp_dict = {}
for residency in residency_list:
    temp_dict["name"] = residency
    nodes.append(temp_dict.copy())
nodes


# Now we have a clean set of nodes.
# 
# Now that we can do this scraping for one fellowship/residency, we need to do it for all of them:

# In[ ]:



