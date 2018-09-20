# Lab 1 - *Tumblr-Feed*

**Tumblr-Feed** is a photo browsing app using the [The Tumblr API](https://www.tumblr.com/docs/en/api/v2#posts).

Time spent: **5** hours spent in total

## User Stories

The following **required** user stories are complete:

- [x] User can scroll through a feed of images returned from the Tumblr API (5pts)

The following **stretch** user stories are implemented:

- [x] User sees an alert when there's a networking error (+1pt)
- [x] While poster is being fetched, user see's a placeholder image (+1pt)
- [x] User sees image transition for images coming from network, not when it is loaded from cache (+1pt)
- [x] Customize the selection effect of the cell (+1pt)

The following **additional** user stories are implemented:

- [x] List anything else that you can get done to improve the app functionality! (+1-3pts)
    1. How about loading first 10 photos and then if I want 10 more photos I just scroll up and get 10 more photos.
    2. When clicked on a picture I should go to a different controller and show more info about it. 

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. The placeholder image, why this time in the lab as opposed to the assignment Flix, my image was cut off.
2. I would like to talk about the load more photos at the end of the scrolling. 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<div style="display: inline-block;">
<img float="left" width="250" height="500" src='https://user-images.githubusercontent.com/16315708/45463509-69dcbd80-b6da-11e8-9149-33cc81ea1b14.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<div/>

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.
Lab was pretty much same as the previous assignment, basically everything I did before I implemented here. I had no issues other than the placeholder image was not fitting the UIImageView properly. 

## License

Copyright [2018] [Luis Mendez]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


# Lab 2 - *Tumblr-Feed*

**Tumblr-Feed** is a photo browsing app app using the [The Tumblr API](https://www.tumblr.com/docs/en/api/v2#posts).

Time spent: **10** hours spent in total

## User Stories

The following **required** user stories are complete:

- [x] User can tab an image to view a larger image in a detail view (5pts)

The following **stretch** user stories are implemented:

- [x] Add Avatar and Publish Dates (+2pt)
- [x] Zoomable Photo View (+2pt)
- [x] Infinite Scrolling (+2pt)

The following **additional** user stories are implemented:

- [x] List anything else that you can get done to improve the app functionality! (+1-3pts)
    - We can add more details in the detail View and not only the image
    - We can a request of only 10 posts and with the infinite scrolling we can get 10 more and so on.
    - Constraints specially on the scrolling view, it seems to be confusing when I apply them.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I want to discuss how to make the infinite scrolling more efficient and how to apply good constraints to it.
2. I also want to discuss how methods and attributes of the infinite scrolling work to know how to set it to my preference.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<div style="display: inline-block;">
<img float="left" width="250" height="500" src='https://user-images.githubusercontent.com/16315708/45794655-8e4e1200-bc65-11e8-85c8-0ddac72c1ecd.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<div/>
GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

    - I couldn't zoom in or out on the pictures not because the code was wrong but I just didn't know I had to hold alt + click and then drag. I was having a hard time there.
    - I was confused on the infinite scrolling I could not see the activity indicator being applied. I also saw some bouncing when I reached the end of the table, not sure why it did that. 

## License

    Copyright [2018] [Luis Mendez]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
