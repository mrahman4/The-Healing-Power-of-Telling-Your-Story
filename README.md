## Inspiration
Many diseases are treatable but not curable. Living with such disease is an ongoing learning experience for patients and families. They share their journey to champion hope.

This application is a platform giving patients and parents needed tool to share their stories and reach out to the community. There is many portals & community support the same idea. However all those platforms only support local community, where patient only contact with others who talk the same language. Using AWS AI services we enhance the idea to build bigger community not limited to nation or language. **Patient Stories from Around the World.**
- User can see all other users post, seeing the recent posts first.
- User can add his posts. Posts can contains patient story, milestones in his journey, feedback (about certain hospital, clinic, doctor,..), asking for advise or share his experience with others.
- Add comments to other posts, give a hand, advise, lesson learned or at least supportive words
- Search in other stories to get posts talked in certain topic.


Application in current phase support 3 languages: Arabic, French & English. Architect solution that can give good performance while translating user posts from his original language to the other 2 languages and how user can search using his languages in posts (from all language) and return to him immediately. This can be achieved by
- Extract keywords from the post (in case of English & french or by translating Arabic post to English then extract the keywords)
- Translating the post & keywords to the other 2 languages
- Then when user inquire the timeline (or inquire based on search query), data will be retrieved quickly as translation done once while adding

## Technologies used
- It is mobile application developed by Flutter (cross mobile development platform).
- For user registration and authentication I used AWS Cognition
- Stories saved in AWS RDS mysql DB
- To extract keywords from stories, Amazon Comprehension is used. Those keywords are used to facilitate user search
- Translation between Arabic, English & french is done using Amazon Translation. Translation is done for stories and extracted keywords.  


## What's next for The Healing Power of Telling Your Story
It will be a long Journey, for example :
- **Categorize stories based on disease type. So each user can join certain community.**
- Get more user information such as countries, town, age,..
- Some disease is related to user children, so I want both father & mother can add posts to the same child
- Update GUI titles based on user language
- Show number of comments on each post
- Add notifications
