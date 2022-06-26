import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/database_handler.dart';
import 'package:sous_chef/destinations/ingredient_destination.dart';
import 'package:sous_chef/objects/directory.dart';
import '../../destination.dart';
import '../../destinations/recipe_destination.dart';
import '../../objects/ingredient.dart';
import '../../objects/instruction.dart';
import '../../objects/method.dart';
import '../../objects/recipe.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage(
      { required Key key,
        required this.destination,
      }) : super(key: key);
  final Destination destination;

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {

  DatabaseHandler dbHandler = DatabaseHandler();

  List<TextEditingController> descriptionFields = [];
  List<TextEditingController> durationFields = [];
  TextEditingController nameCtrlr = TextEditingController(text: "bah");
  TextEditingController ingredientsCtrlr = TextEditingController(
      text:"some ingredients"
  );
  IconButton saveBtn = IconButton(onPressed: () {}, icon: const Icon(Icons.save),);

  appendInstructions(instructions) {
    setState(() {
      for (List<String> i in instructions) {
        descriptionFields.add(TextEditingController(text: i[0]));
        durationFields.add(TextEditingController(text: i[1]));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    dbHandler.open().whenComplete(() => setState(() {}));

    // Load in ingredient information
    Future.delayed(Duration.zero, () {
      RecipeParcel parcel = ModalRoute.
      of(context)!.settings.arguments as RecipeParcel;
      if (parcel.isExisting) {
        // Editing an existing ingredient
        Recipe recipe = parcel.recipe!;
        nameCtrlr = TextEditingController(text: recipe.name);
        saveBtn = buildSaveExistingButton(dbHandler, parcel.recipe!);
        ingredientsCtrlr = TextEditingController(
            text: recipe.ingredients
        );
        List<Method> method = recipe.getMethod();
        for (Method m in method) {
          descriptionFields.add(TextEditingController(
              text: m.description)
          );
          durationFields.add(TextEditingController(
              text: m.duration.toString())
          );
        }
      }
      else {
        // Creating a new ingredient
        nameCtrlr = TextEditingController(text: "");
        saveBtn = buildSaveNewButton(dbHandler, nameCtrlr, parcel);
        ingredientsCtrlr = TextEditingController(
            text:"ingredient1, ingredient2, ingredient3, ..."
        );
        // Add an example instructions
        descriptionFields.add(TextEditingController(
            text: "Wash, peal and chop into sticks.")
        );
        durationFields.add(
            TextEditingController(text: "10")
        );
      }
    } );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(),
      body: Card(
        margin: const EdgeInsets.all(12.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTitle(nameCtrlr),
              buildIngredientList(),
              buildListHeader(),
              Divider(),
              Flexible(
                fit: FlexFit.tight,
                child: ListView.builder(
                    itemCount: descriptionFields.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Icon(Icons.delete_forever),
                        ),
                        key: UniqueKey(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                          child: ListTile(
                              title: TextField(
                                controller: descriptionFields[index],
                                minLines: 1,
                                maxLines: 10,
                              ),
                              trailing: SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: durationFields[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                ),
                              )
                          ),
                        ),
                      );
                    }
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  appendInstructions([["New instruction", "10"]]);
                },
                icon: const Icon(
                  Icons.add,
                ), label: const Text("Add Instruction"),
              ),
            ],
          ),
        ),

    );
  }

  AppBar buildAppBar() => AppBar(
    title: Text(widget.destination.title),
    actions: [
      saveBtn,
    ],
  );

  Widget buildTitle(TextEditingController ctrlr) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 48.0),
        child: TextField(
          controller: ctrlr,
          decoration: InputDecoration(hintText: 'Honey Roasted Carrots'),
          textAlign: TextAlign.center,
        ),
      );

  Widget buildIngredientList() =>
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 2.0),
            child: Text(
              "Ingredients",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 2.0),
            child: TextField(
                controller: ingredientsCtrlr,
                textAlign: TextAlign.left,
            ),
          )
        ],
      );

  Widget buildListHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Method",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Icon(Icons.timer,),
      ],
    ),
  );

  IconButton buildSaveNewButton(
      DatabaseHandler dbHandler,
      TextEditingController nameCtrlr,
      RecipeParcel parcel) => IconButton(
    onPressed: () {
      Future<int> id = dbHandler.insertRecipe(Recipe.createRecipeInsert(
          name: nameCtrlr.text.toString(),
          directory: parcel.dirId,
          ingredients: ingredientsCtrlr.text.toString()),
          gatherMethod());
      Navigator.pushNamed(context, RecipeRoutes.list);
    },
    icon: getSaveIcon(),
  );

  IconButton buildSaveExistingButton(
      DatabaseHandler dbHandler,
      Recipe recipe) => IconButton(
          onPressed: () {
            recipe.name = nameCtrlr.text.toString();
            recipe.ingredients = ingredientsCtrlr.text.toString();
            dbHandler.updateRecipe(recipe, gatherMethod());
            Navigator.pushNamed(context, RecipeRoutes.list);
          },
          icon: getSaveIcon(),
        );

  Icon getSaveIcon() => const Icon(Icons.check);


  List<List<String>> gatherMethod() {
    // add all instructions for this ingredient
    List<List<String>> method = [];
    for (int i = 0; i < descriptionFields.length; i++) {
      method.add([descriptionFields[i].text.toString(),
        durationFields[i].text.toString()]);
    }
    return method;
  }

}