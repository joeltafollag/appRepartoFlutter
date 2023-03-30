import 'package:enermax_reparto/models/manifiestos.dart';
import 'package:enermax_reparto/screens/manifiestos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class CardWidget extends StatelessWidget {
  final manifiestos manifiestosList;
  const CardWidget({
    Key? key,
    required this.manifiestosList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: manifiestosList.estatus == 2 ? Color.fromRGBO(0, 140, 221, 1):
        manifiestosList.estatus == 1 ?Colors.lightGreen : Colors.white,
        elevation: 8,
        shadowColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          minLeadingWidth:  2,
          leading: Container(
                  width: 3,
                  color: manifiestosList.estatus == 0 ? Color.fromRGBO(0, 140, 221, 1):
        manifiestosList.estatus == 2 ? Colors.white :  Colors.white,
                ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              manifiestosList.Generador,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: manifiestosList.estatus == 0 ? Color.fromRGBO(0, 140, 221, 1) :
                Colors.white
              ),
            ),
          ),
          subtitle: Text(
            manifiestosList.Domicilio,
            style: TextStyle(
              color: manifiestosList.estatus == 0 ? Color(0xff2da9ef):
              manifiestosList.estatus == 2 ? Colors.white : Colors.white ,
              fontSize: 15,
            ),
          ),
          trailing: Text(""
            /* task.inicio != null && task.fin != null ? 
            '${DateFormat('hh:mm a').format(task.inicio!)} \n${DateFormat('hh:mm a').format(task.fin!)}' 
            : task.inicio != null && task.fin == null ? 
            '${DateFormat('hh:mm a').format(task.inicio!)} \n      --:--'
            :'--:-- \n--:--',
            style: TextStyle(
              color: task.estatus == 0 ? Colors.white:
              task.estatus == 2 ? Colors.white : Colors.blue.shade700,
              fontSize: 16,
            ), */
          ),
        ),
    );
  }
}