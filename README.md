### Steps to Run the App
1. Clone the repo and open the project in XCode.
2. To test different api request cases (success / empty list / malormed data), open `FetchRepo` and change `line 12` to one of the following options: `FetchEndpoint.recipes` / `FetchEndpoint.malformedRecipes` / `FetchEndpoint.emptyRecipes`.
3. Run the app

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I focused on two primary areas for this project:

1.	Architecture:
Scalability requires a strong architectural foundation. Beyond implementing the MVVM pattern, I leveraged dependency injection and protocol conformance to isolate components while maintaining testability.

I also structured the app into distinct business layers: networking, repository, data, and UI/interaction. This separation ensures that logic resides in the appropriate layers, enhancing maintainability and scalability.

3.	Testability and Resilience:
I emphasised creating a robust, testable architecture that allowed for accurate validation of key logic while ensuring the app performs well across various scenarios.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
Suggest time: 4-5 hours
Actual time: ~6 hours

I dedicated the additional time to refining two areas (based on the suggestion that I provide a "production ready" product:
1.	Perfecting a clean, responsive UI that handles all device sizes and rotations.
2.	Achieving full test coverage for the core app logic.

I allocated roughly half the time to architecture-related code, as I consider it the cornerstone of a scalable and maintainable app. The remaining time was spent ensuring network requests were handled correctly and tests provided accurate validation.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
The primary trade-off was time. While I exceeded the suggested timeframe, I believe that delivering a high-quality product outweighs the benefit of adhering to deadlines too strictly (assuming an agreement is made on this by all teams involved!). This decision allowed me to focus on creating a solid application that handles edge-cases (both stipulated and not) successfully.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The areas I felt less confident in were caching and Swift concurrency:
•	Caching:
I typically use third-party libraries (e.g., Kingfisher for image loading), but the project constraints required a custom solution. This added time as I looked for an effective alternative.

•	Swift Concurrency:
My experience with Swift concurrency is limited as it hasn’t been a requirement in my past projects. While I learned quickly and applied it here, I recognise this as an area for future growth.
