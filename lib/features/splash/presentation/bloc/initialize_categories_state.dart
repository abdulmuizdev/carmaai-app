abstract class InitializeCategoriesState {
  const InitializeCategoriesState();
}

class Initial extends InitializeCategoriesState {
  const Initial();
}

class InitializingCategories extends InitializeCategoriesState {
  const InitializingCategories();
}

class InitializeCategoriesError extends InitializeCategoriesState {
  final String message;
  const InitializeCategoriesError(this.message);
}

class InitializedCategories extends InitializeCategoriesState {
  const InitializedCategories();
}

