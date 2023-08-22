import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/models/todo_model.dart';
import 'package:flutter_todo_app/ui/screens/create_update_todo_screen.dart';
import 'package:flutter_todo_app/ui/screens/todo_detail_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'ui/screens/todo_list_screen.dart';

void main() async {
  //Initializes the HiveStore used for caching
  await initHiveForFlutter();

  final GraphQLClient graphQLClient = GraphQLClient(
    link: HttpLink("https://graphqlzero.almansi.me/api"),
    cache: GraphQLCache(
      store: HiveStore(),
    ),
  );

  final client = ValueNotifier(graphQLClient);
  runApp(
    GraphQLProvider(
      client: client,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TodoList GraphQL',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: {
          "/": (context) => const TodoListScreen(),
          '/detail': (context) {
            final todoId = ModalRoute.of(context)?.settings.arguments as String;
            return TodoDetailScreen(todoId: todoId);
          },
          '/create-update-todo': (context) {
            final todoItem =
                ModalRoute.of(context)?.settings.arguments as TodoModel?;
            return CreateUpdateTodoScreen(todo: todoItem);
          }
        });
  }
}
