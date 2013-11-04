flatiron-playlister
===================

-  fork this repositry
-  clone it locally
-  add this repo as the local upsteam like so:  
```git add remote upstream git@github.com:oneteam-onedream/flatiron-playlister.git```
-  checkout a branch for your work:  
```checkout -b <your_feature_name>``` 
  -  try to use descriptive name for branch eg. 'spotify-web', 'upvote-bugfix', etc
-  when feature is complete, push your feature branch up to your github account(origin)
    ```git push origin <your_feature_name>```
-  make a pull request to merge your feature branch to the oneteam-onedream master branch
    -  do not merge your pull requests, we should all be on the same page about the content being merged
    -  when you work, be sure to be up to date with the upstream/master branch. It's good habit to pull often
    -  AWESOME!


TODO
====
- spotify search and stream  
- AJAX  
- voting bugfix (needs to remember ip of voter) 
- `play` needs to affect the song list
  

down the line 
------
- css  
- images  
- deployment  
 - transition from sequel to active record  
  - this will entail switching from sqlite3 to postgres or something of the like
