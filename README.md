### Steps to Run the App
1. Clone the repo and open the project in XCode.
2. To test different api request cases (success / empty list / malormed data), open `FetchRepo` and change `line 12` to one of the following options: `FetchEndpoint.recipes` / `FetchEndpoint.malformedRecipes` / `FetchEndpoint.emptyRecipes`.
3. Run the app

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I focused on two areas primarily or this project. 

First, was architecture. In order for an app to scale well, it needs to be backed by a strong architectural foundation. 

Aside from using the MVVM pattern here, I used dependency injection and protocol conformance to ensure each aspect of the app's architecture was isolated but also highly testable - I was able to create Mock classes where needed to make testing easier.

Breaking the architecture down into clear business layers helps separate logic into appropriate areas - a networking layer, a repo layer, a data layer, and a ui/interaction layer. Again, this helps set a base for the app to scale well, ensuring that appropriate logic lives in the appropaite layers.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
Suggest time: 4-5 hours

I ended up spending around 6 hours on the project - the extra time was spent perfecting two areas - create a clean UI that handled all device sizes and rotatione, and second, ensuring full coverage of the main app-logic.

I spent roughly half the time building out the architecture-related code and logic - architecture, to me, is the basis for which all success is built on!!

The rest of the time was taken up with ensuring network requests were handled correctly, and tests were accurately testing the logic

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
My main trade-off was probably time. I believe the ensuring a rock-solid product is more important than meeting a deadline, which is partly why I over-shot the suggested timeframe for completion.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The area that I have the least confidence in is probably the caching and use of Swift concurrency. For the former, I have always used third-party libraries (Kingfisher for image laoding, specifically) and it took more time seeking a solution that met the constraints laid out for the project.
From a Swift concurrency perspective - this is an area I have not spent much time in as the projects I've worked on thus far have not utilized it. I do learn fast, but this is the first time I've truly dabbled in utilizing the new framework.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
