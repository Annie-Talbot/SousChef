import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/database_handler.dart';
import 'package:sous_chef/destinations/ingredient_destination.dart';
import 'package:sous_chef/objects/directory.dart';
import '../../destination.dart';
import '../../objects/ingredient.dart';
import '../../objects/instruction.dart';

class IngredientDetailPage extends StatefulWidget {
  const IngredientDetailPage(
      { required Key key,
        required this.destination,
        }) : super(key: key);
  final Destination destination;

  @override
  _IngredientDetailPageState createState() => _IngredientDetailPageState();
}

class _IngredientDetailPageState extends State<IngredientDetailPage> {

  DatabaseHandler dbHandler = DatabaseHandler();

  List<TextEditingController> descriptionFields = [];
  List<TextEditingController> durationFields = [];
  TextEditingController nameCtrlr = TextEditingController(text: "bah");
  FloatingActionButton saveBtn = FloatingActionButton(onPressed: () {});

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
      IngredientParcel parcel = ModalRoute.
                    of(context)!.settings.arguments as IngredientParcel;
      if (parcel.isExisting) {
        // Editing an existing ingredient
        Ingredient ingredient = parcel.ingredient!;
        nameCtrlr = TextEditingController(text: ingredient.name);
        saveBtn = buildSaveExistingButton(dbHandler,
            nameCtrlr, parcel.ingredient!);

        List<Instruction> instructions = ingredient.getInstructions();
        for (Instruction i in instructions) {
          descriptionFields.add(TextEditingController(
              text: i.description)
          );
          durationFields.add(TextEditingController(
              text: i.duration.toString())
          );
        }
      }
      else {
        // Creating a new ingredient
        nameCtrlr = TextEditingController(text: "");
        saveBtn = buildSaveNewButton(dbHandler, nameCtrlr, parcel);
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
          margin: EdgeInsets.all(12.0),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildTitle(nameCtrlr),
                buildListHeader(),
                buildDivider(0.0),
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
                IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    appendInstructions([["New instruction", "10"]]);
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                ),
              ],
            ),
          ),
        ),
      floatingActionButton: saveBtn,

    );
  }

  AppBar buildAppBar() => AppBar(
    title: Text(widget.destination.title),
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

  Widget buildDivider(double height) => Divider(
    height: height,
    color: Theme.of(context).colorScheme.primary,
    thickness: 1.0,
  );

  Widget buildListHeader() => ListTile(
    title: Text(
      "Instruction",
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    ),
    trailing: Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Icon(
        Icons.timer,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );

  FloatingActionButton buildSaveNewButton(
      DatabaseHandler dbHandler,
      TextEditingController nameCtrlr,
      IngredientParcel parcel) => FloatingActionButton(
        onPressed: () {
          Future<int> id = dbHandler.insertIngredient(Ingredient.createIngredientInsert(
              name: nameCtrlr.text.toString(),
              directory: parcel.dirId), gatherInstructions());
          Navigator.pushNamed(context, IngredientRoutes.list);
        },
        child: getSaveIcon(),
  );

  FloatingActionButton buildSaveExistingButton(
      DatabaseHandler dbHandler,
      TextEditingController nameCtrlr,
      Ingredient ingredient) => FloatingActionButton(
        onPressed: () {
          ingredient.name = nameCtrlr.text.toString();
          dbHandler.updateIngredient(ingredient, gatherInstructions());
          Navigator.pushNamed(context, IngredientRoutes.list);
        },
        child: getSaveIcon(),
  );

  Icon getSaveIcon() => const Icon(Icons.check);


  List<List<String>> gatherInstructions() {
    // add all instructions for this ingredient
    List<List<String>> instructions = [];
    for (int i = 0; i < descriptionFields.length; i++) {
      instructions.add([descriptionFields[i].text.toString(),
          durationFields[i].text.toString()]);
    }
    return instructions;
  }

}