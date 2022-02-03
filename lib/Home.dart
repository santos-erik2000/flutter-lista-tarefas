// ignore: file_names
// ignore_for_file: deprecated_member_use, avoid_print, unnecessary_brace_in_string_interps, file_names, prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:minhas_anotacoes/model/Anotacao.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

  exibirTelaCadastro() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Título", hintText: "Digite um Titulo"),
                  controller: _tituloController,
                  autofocus: true,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Descrição", hintText: "Digite uma Descrição"),
                  controller: _descricaoController,
                )
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")),
              FlatButton(
                  onPressed: _salvarAnotacao,
                  // ignore: unnecessary_string_interpolations
                  child: Text("Salvar"))
            ],
          );
        });
  }

  _recuperarAnotacao() async {
    List listaAnotacaoRetornada = await _db.listarAnotacao();
    List<Anotacao> listatemporaria = [];
    // ignore: avoid_function_literals_in_foreach_calls
    listaAnotacaoRetornada.forEach((item) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listatemporaria.add(anotacao);
    });
    setState(() {
      _anotacoes = listatemporaria;
    });
    print("ANOTAÇÕES: " + listaAnotacaoRetornada.toString());
  }

  _salvarAnotacao() async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    print("data Atual: " + DateTime.now().toString());
    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int id = await _db.salvarAnotacao(anotacao);
    print("SALVAR ID: " + id.toString());

    limpaCampos();
    Navigator.pop(context);
    _recuperarAnotacao();

  }

  _exclusaoAnotacao(int? idAnotacao) {
    print("ID: " + idAnotacao.toString());
  }

  _formatarData(String? data) {
    initializeDateFormatting("Pt-BR");
    // var formatador = DateFormat("d/M/y H:m"); Com Horas
    var formatador = DateFormat("d/M/y");
    return formatador.format(DateTime.parse(data!));
  }

  void limpaCampos() {
    _tituloController.clear();
    _descricaoController.clear();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _recuperarAnotacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _anotacoes.length,
                itemBuilder: (context, index) {
                  var item = _anotacoes[index];
                  return Card(
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            ),
                            onTap: exibirTelaCadastro,
                          ),
                          GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                            onTap: _exclusaoAnotacao(item.id),
                          )
                        ],
                      ),
                      title: Text("${item.titulo}"),
                      subtitle: Text(
                          "${_formatarData(item.data)} - ${item.descricao}"),
                    ),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: exibirTelaCadastro,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
