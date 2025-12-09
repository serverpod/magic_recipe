import 'package:flutter/material.dart';
import 'package:magic_recipe_client/magic_recipe_client.dart';
import 'package:magic_recipe_flutter/main.dart';
import 'package:magic_recipe_flutter/pages/pages.dart';
import 'package:magic_recipe_flutter/widgets/widgets.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  /// Holds the last result or null if no result exists yet.
  Recipe? _recipe;

  /// Holds the recipe history.
  List<Recipe> _recipeHistory = [];

  /// Holds the last error message that we've received from the server or null if no
  /// error exists yet.
  String? _errorMessage;

  final _ingredientsController = TextEditingController();
  String? _imagePath;

  bool _isLoading = false;

  bool get _isAdmin {
    final scopeNames = client.auth.authInfo?.scopeNames ?? {};
    return scopeNames.contains('serverpod.admin');
  }

  @override
  void initState() {
    super.initState();
    _loadRecipeHistory();
  }

  @override
  void dispose() {
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipeHistory() async {
    try {
      final recipes = await client.recipes.getRecipes();
      setState(() => _recipeHistory = recipes);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to load recipes: $e');
    }
  }

  void _generateRecipe() async {
    try {
      setState(() {
        _errorMessage = null;
        _recipe = null;
        _isLoading = true;
      });
      final result = await client.recipes.generateRecipe(
        _ingredientsController.text,
        _imagePath,
      );
      setState(() {
        _errorMessage = null;
        _recipe = result;
        _recipeHistory.insert(0, result);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '$e';
        _recipe = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: _navigateToAdmin,
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: RecipeHistorySidebar(
              recipes: _recipeHistory,
              onRecipeSelected: _selectRecipe,
              onRecipeDeleted: _deleteRecipe,
            ),
          ),
          Expanded(
            flex: 3,
            child: RecipeGeneratorPanel(
              ingredientsController: _ingredientsController,
              imagePath: _imagePath,
              isLoading: _isLoading,
              recipe: _recipe,
              errorMessage: _errorMessage,
              onGenerateRecipe: _generateRecipe,
              onImagePathChanged: (path) => setState(() => _imagePath = path),
            ),
          ),
        ],
      ),
    );
  }

  void _selectRecipe(Recipe recipe) {
    setState(() {
      _errorMessage = null;
      _ingredientsController.text = recipe.ingredients;
      _imagePath = recipe.imagePath;
      _recipe = recipe;
    });
  }

  void _deleteRecipe(Recipe recipe, int index) async {
    try {
      await client.recipes.deleteRecipe(recipe.id!);
      setState(() => _recipeHistory.removeAt(index));
    } catch (e) {
      setState(() => _errorMessage = 'Failed to delete recipe: $e');
    }
  }

  void _handleLogout() async {
    await client.auth.signOutDevice();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _navigateToAdmin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
    );
  }
}

class RecipeHistorySidebar extends StatelessWidget {
  final List<Recipe> recipes;
  final ValueChanged<Recipe> onRecipeSelected;
  final Function(Recipe, int) onRecipeDeleted;

  const RecipeHistorySidebar({
    super.key,
    required this.recipes,
    required this.onRecipeSelected,
    required this.onRecipeDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeListTile(
            recipe: recipe,
            onTap: () => onRecipeSelected(recipe),
            onDelete: () => onRecipeDeleted(recipe, index),
          );
        },
      ),
    );
  }
}

class RecipeListTile extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const RecipeListTile({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onDelete,
  });

  String get title {
    final firstLineEnd = recipe.text.indexOf('\n');
    return firstLineEnd != -1
        ? recipe.text.substring(0, firstLineEnd)
        : recipe.text;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('${recipe.author} - ${recipe.date}'),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}

/// RecipeGeneratorPanel contains the input fields and controls for the recipe generator.
class RecipeGeneratorPanel extends StatelessWidget {
  final TextEditingController ingredientsController;
  final String? imagePath;
  final bool isLoading;
  final Recipe? recipe;
  final String? errorMessage;
  final VoidCallback onGenerateRecipe;
  final ValueChanged<String?> onImagePathChanged;

  const RecipeGeneratorPanel({
    super.key,
    required this.ingredientsController,
    required this.imagePath,
    required this.isLoading,
    required this.recipe,
    required this.errorMessage,
    required this.onGenerateRecipe,
    required this.onImagePathChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextField(
              controller: ingredientsController,
              decoration: const InputDecoration(
                hintText: 'Enter your ingredients',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RecipeControls(
              isLoading: isLoading,
              imagePath: imagePath,
              onGenerateRecipe: onGenerateRecipe,
              onImagePathChanged: onImagePathChanged,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: RecipeResultDisplay(
                recipe: recipe,
                errorMessage: errorMessage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// RecipeControls contains the buttons for the recipe generator.
class RecipeControls extends StatelessWidget {
  final bool isLoading;
  final String? imagePath;
  final VoidCallback onGenerateRecipe;
  final ValueChanged<String?> onImagePathChanged;

  const RecipeControls({
    super.key,
    required this.isLoading,
    required this.imagePath,
    required this.onGenerateRecipe,
    required this.onImagePathChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : onGenerateRecipe,
          child: Text(isLoading ? 'Loading...' : 'Send to Server'),
        ),
        ImageUploadButton(
          key: ValueKey(imagePath),
          onImagePathChanged: onImagePathChanged,
          imagePath: imagePath,
        ),
      ],
    );
  }
}

/// RecipeResultDisplay shows the result of the call: either the returned result from
/// the recipes endpoint method or an error message.
class RecipeResultDisplay extends StatelessWidget {
  final Recipe? recipe;
  final String? errorMessage;

  const RecipeResultDisplay({
    super.key,
    this.recipe,
    this.errorMessage,
  });

  String get _displayText {
    if (errorMessage != null) return errorMessage!;
    if (recipe != null) {
      return '${recipe!.author} on ${recipe!.date}:\n${recipe!.text}';
    }
    return 'No server response yet.';
  }

  Color get _backgroundColor {
    if (errorMessage != null) return Colors.red[300]!;
    if (recipe != null) return Colors.green[300]!;
    return Colors.grey[300]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _backgroundColor,
      constraints: const BoxConstraints(minHeight: 50),
      child: Center(child: Text(_displayText)),
    );
  }
}
