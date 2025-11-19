# Magic Recipe Course - Commit Plan

This document outlines the commit structure for the Magic Recipe Serverpod course, breaking down each lesson into specific commits that build upon each other progressively.

## Course Structure & Commit Breakdown

### Section 4: Make your first calls - Working with Endpoints

#### 4.1 💻 Create your free Gemini API key (1:53)

**Commit:** `Add passwords.yaml file`

- Add API key configuration to `magic_recipe_server/config/passwords.yaml`
- Configure Gemini API key placeholder

#### 4.2 💻 Create your first endpoint (8:22)

**Commit:** `Add RecipesEndpoint`

- Create `RecipesEndpoint` class in `magic_recipe_server/lib/src/recipes/endpoints/recipes_endpoint.dart`
- Implement basic `generateRecipe` method returning a simple string
- Register endpoint in server configuration

#### 4.3 💻 Call the endpoint & run the app (5:44)

**Commit:** `Call RecipesEndpoint from app`

- Update Flutter app to call the `generateRecipe` endpoint
- Add basic UI with text input and result display
- Handle loading states and errors

#### 4.4 The basic development loop (4:01)

*No specific commit - covered in documentation*

#### 4.5 Backwards compatibility for endpoints (1:21)

*No specific commit - covered in documentation*

### Section 5: Rise and shine - Working with Models

#### 5.1 How Serverpod defines models (2:50)

*No specific commit - theory section*

#### 5.2 💻 Create a "Recipe" model (5:57)

**Commit:** `Add Recipe model`

- Create `recipe.spy.yaml` with Recipe model definition in `magic_recipe_server/lib/src/recipes/models/`
- Include fields: author, text, date, ingredients
- Generate protocol files

#### 5.3 💻 Use the model in the server & generate (2:27)

*Included in previous commit*

#### 5.4 💻 Use the model in the client & run the app (3:20)

**Commit:** `Update app to use recipe model`

- Update UI to display Recipe object fields
- Format recipe display with author, ingredients, text, and date

#### 5.5 Backwards compatibility for Models (0:30)

*No specific commit - covered in documentation*

### Section 6: A memory game - Working with the Database

#### 6.1-6.4 Database concepts (Theory)

*No specific commit - theory sections*

#### 6.5 💻 Creating a table for our recipes (2:40)

**Commit:** `Create table for Recipe`

- Update `recipe.spy.yaml` to include table configuration
- Generate and apply database migration
- Add `id` field and table annotations

#### 6.6 💻 Writing the recipe to the database (2:35)

**Commit:** `Store Recipe in database`

- Update `generateRecipe` to save Recipe to database
- Return the saved recipe with generated ID

#### 6.7 💻 Reading from the database (2:45)

**Commit:** `Read recipes from database`

- Create `getRecipes` method in RecipesEndpoint
- Query all recipes from database

#### 6.8 💻 Call the endpoint from the app (2:32)

**Commit:** `Update app to show recipes from database`

- Create recipe list UI
- Call `getRecipes` endpoint
- Display list of saved recipes

#### 6.9 The development loop revisited (4:01)

*No specific commit - covered in documentation*

#### 6.10 Inspecting the database with a database viewer (3:03)

**Commit:** `sqltools`

- Add database inspection configuration
- Document using database viewers

### Section 7: We've got you covered - Writing integration tests

#### 7.1 💻 Testing generateRecipe & mocking Gemini (11:50)

**Commit:** `Add integration tests for generateRecipe`

- Create integration test setup in `magic_recipe_server/test/integration/`
- Mock Gemini API calls with `MockRecipeAiService`
- Test recipe generation and database storage

#### 7.2 💻 Create and test a deletion endpoint (9:11)

**Commit:** `Add soft delete for recipes`

- Add `deletedAt` field to Recipe model
- Create `deleteRecipe` endpoint with soft delete
- Add integration tests for deletion
- Update `getRecipes` to filter out deleted recipes

### Section 8: Remember me - Adding Authentication

#### 8.1 💻 Adding the authentication module to our server (4:48)

**Commit:** `Add auth module to server`

- Add auth dependencies to pubspec.yaml
- Configure authentication in server
- Set up email authentication with `EmailIdpEndpoint`

#### 8.2 💻 Adding the authentication to our Flutter app (4:19)

**Commit:** `Add auth module to app`

- Add auth dependencies to Flutter app
- Create login/signup UI in `pages/login.dart`
- Implement authentication flow

#### 8.3 💻 Adding "Ownership" to our recipes (8:57)

**Commit:** `Add ownership to recipe`

- Add `userId` field to Recipe model
- Update endpoints to require authentication
- Filter recipes by user ownership
- Generate and apply database migration

#### 8.4 Database relations - User relation vs userId

*No specific commit - covered in documentation*

### Section 9: Overwatch - Add an admin dashboard

#### 9.1 💻 Adding scopes on user creation with the user created hook (2:14)

**Commit:** `Add admin scope on user created`

- Implement user creation hook in `auth/email_idp_endpoint.dart`
- Assign admin scope to @serverpod.dev emails
- Configure scope-based permissions

#### 9.2 💻 Creating a scoped admin endpoint (3:02)

**Commit:** `Add admin endpoint with access scope`

- Create admin endpoint with scope restrictions in `auth/endpoints/`
- Add method to get all recipes (admin only)
- Implement scope validation with `AdminEndpointBase`

#### 9.3 💻 Updating the UI (4:30)

**Commit:** `Add admin dashboard to app`

- Create admin dashboard UI in `pages/admin_dashboard_page.dart`
- Add admin-only recipe management
- Implement role-based UI navigation

### Section 10: A time keeper - Scheduling work for the future

#### 10.1 💻 Create a FutureCall (4:16)

**Commit:** `Add future call to remove deleted recipes`

- Create FutureCall class in `recipes/future_calls/remove_deleted_recipes_future_call.dart`
- Implement logic to permanently delete old soft-deleted recipes

#### 10.2 💻 Test a FutureCall (1:26)

**Commit:** `Add tests for future call`

- Test FutureCall execution in `test/integration/remove_deleted_recipes_future_call_test.dart`
- Verify cleanup functionality

#### 10.3 💻 Scheduling FutureCalls (5:01)

**Commit:** `Add scheduler for future call`

- Add scheduling logic for FutureCall
- Configure automatic cleanup intervals

#### 10.4 Insights - The Serverpod Devtools (2:32)

*No specific commit - covered in documentation*

### Section 11: Don't ask me twice - Add caching

#### 11.1 How caching works and what caches we have (2:01)

*No specific commit - theory section*

#### 11.2 💻 Caching our recipe (5:51)

**Commit:** `Add caching to generateRecipe`

- Implement Redis caching for generated recipes
- Cache based on ingredients input
- Add cache invalidation logic

#### 11.3 💻 Testing that caching works (1:22)

**Commit:** `Add tests to check caching`

- Test cache hit/miss scenarios
- Verify cache performance improvements

### Section 12: Can I have that? - Add file upload

#### 12.1 💻 Uploading to our server (9:03)

**Commit:** `Add image upload to server`

- Add file upload endpoints
- Configure file storage
- Add image processing for recipe generation

#### 12.2 💻 Updating the tests

**Commit:** `Update tests after image upload`

- Add tests for file upload endpoints
- Test image-based recipe generation

#### 12.3 💻 Updating the Flutter app (5:11)

**Commit:** `Add image upload to app`

- Add image picker functionality in `widgets/image_widgets.dart`
- Implement image upload UI
- Integrate image upload with recipe generation

### Section 13: Let it flow - Add streaming

#### 13.1 Quick primer on Dart streams

*No specific commit - theory section*

#### 13.2 💻 Refactoring our method to stream the recipe (5:22)

**Commit:** `Add streaming generate recipe endpoint`

- Create `generateRecipeStream` method
- Stream recipe generation progress
- Maintain backward compatibility

#### 13.3 💻 Refactor Flutter App for streaming (1:43)

**Commit:** `Listen to stream in app`

- Implement stream listening in UI
- Show real-time recipe generation progress
- Update UI to handle streaming data

### Section 14: Ship faster - Hosting a Flutter Web App

#### 14.1 💻 Building the Flutter Web app (5:27)

**Commit:** `Host Flutter Web`

- Build Flutter web app with `scripts/build_flutter_web`
- Configure Serverpod to serve web assets in `web/routes/root.dart`
- Add build scripts and deployment configuration

### Section 15: Ready for launch - let's do a quick recap

#### 15.1 What we learned so far and what to do next (1:16)

*No specific commit - covered in final documentation*

## Complete Commit Sequence (Based on Reference Repository)

1. `Inital commit` - Initial Serverpod project setup
2. `Add passwords.yaml file` - Configure API keys
3. `Add RecipesEndpoint` - Create first endpoint
4. `Call RecipesEndpoint from app` - Connect Flutter app
5. `Add Recipe model` - Create Recipe model definition
6. `Update app to use recipe model` - Use Recipe model in Flutter
7. `Create table for Recipe` - Add database table
8. `Store Recipe in database` - Write to database
9. `Read recipes from database` - Read from database
10. `Update app to show recipes from database` - Recipe history view
11. `Add integration tests for generateRecipe` - Testing infrastructure
12. `sqltools` - Database inspection setup
13. `Add soft delete for recipes` - Soft delete functionality
14. `Add auth module to server` - Server authentication
15. `Add auth module to app` - Flutter authentication
16. `Add ownership to recipe` - User ownership
17. `Add admin scope on user created` - Admin scope assignment
18. `Add admin endpoint with access scope` - Admin endpoints
19. `Add admin dashboard to app` - Admin UI
20. `Add future call to remove deleted recipes` - FutureCall creation
21. `Add tests for future call` - FutureCall testing
22. `Add scheduler for future call` - FutureCall scheduling
23. `Add caching to generateRecipe` - Recipe caching
24. `Add tests to check caching` - Cache testing
25. `Add image upload to server` - File upload server
26. `Update tests after image upload` - File upload tests
27. `Add image upload to app` - File upload Flutter
28. `Add streaming generate recipe endpoint` - Streaming server
29. `Listen to stream in app` - Streaming Flutter
30. `Host Flutter Web` - Web hosting

## Implementation Strategy

### Phase 1: Foundation (Commits 1-6)

- Set up basic endpoint and model structure
- Implement core recipe generation functionality

### Phase 2: Database Integration (Commits 7-10)

- Add database storage and retrieval
- Create recipe history functionality

### Phase 3: Testing & Quality (Commits 11-13)

- Add comprehensive testing
- Implement soft delete patterns

### Phase 4: Authentication & Authorization (Commits 14-19)

- Add user authentication
- Implement admin functionality

### Phase 5: Advanced Features (Commits 20-25)

- Add background processing
- Implement caching

### Phase 6: File Handling (Commits 26-28)

- Add file upload capabilities
- Update testing for files

### Phase 7: Real-time Features (Commits 29-30)

- Add streaming capabilities
- Implement web hosting

## Key Architecture Components

### Server Structure

```
magic_recipe_server/
├── lib/src/
│   ├── auth/                    # Authentication system
│   │   ├── admin_endpoint_base.dart
│   │   ├── email_idp_endpoint.dart
│   │   └── endpoints/
│   ├── recipes/                 # Recipe domain
│   │   ├── endpoints/
│   │   ├── exceptions/
│   │   ├── future_calls/
│   │   ├── models/
│   │   └── services/
│   └── web/                     # Web hosting
│       ├── routes/
│       └── widgets/
├── config/                      # Configuration files
├── migrations/                  # Database migrations
└── test/integration/            # Integration tests
```

### Flutter App Structure

```
magic_recipe_flutter/
├── lib/
│   ├── extensions/              # Utility extensions
│   ├── pages/                   # App pages
│   │   ├── admin_dashboard_page.dart
│   │   ├── home.dart
│   │   └── login.dart
│   └── widgets/                 # Reusable widgets
└── web/                         # Web assets
```

## Notes for Implementation

1. **Incremental Development**: Each commit should be fully functional and testable
2. **Backward Compatibility**: Maintain API compatibility where possible
3. **One-line Commit Messages**: Follow the reference repository pattern
4. **Testing**: Add tests progressively throughout development
5. **Migration Strategy**: Handle database migrations carefully
6. **Architecture**: Follow domain-driven design with clear separation of concerns

## Reference Repository

Final structure should match: `/Users/chiziaruhoma/projects/work-projects/Serverpod/magic_recipe_reference`

Key features in final version:

- Complete authentication and authorization system
- File upload and streaming capabilities
- Comprehensive test coverage
- Admin dashboard functionality
- Web hosting integration
- Production-ready configuration
- AI service integration with Gemini API
- Redis caching implementation
- Future call scheduling system
