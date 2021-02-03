import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projeto_final/helpers/database_helper.dart';
import 'package:projeto_final/models/pessoas.dart';
import 'package:projeto_final/pages/pessoa_page.dart';

class Contatos extends StatefulWidget {
  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  DatabaseHelper db = DatabaseHelper();

  List<Pessoa> pessoas = List<Pessoa>();

  @override
  void initState() {
    super.initState();

    Pessoa p = Pessoa(1, 'Romulo', '-46.6388', '-23.5489', null);
    db.insertPessoa(p);
    Pessoa p1 = Pessoa(2, 'Ricardo', '-5.095473', '-42.788969', null);
    db.insertPessoa(p1);
    Pessoa p2 = Pessoa(3, 'Vitor', '-5.055500', '-41.811200', null);
    db.insertPessoa(p2);
    Pessoa p3 = Pessoa(4, 'junior', '-5.008423', '-42.815511', null);
    db.insertPessoa(p3);
    _exibeTodasPessoas();
  }

  void _exibeTodasPessoas() {
    db.getPessoas().then((lista) {
      setState(() {
        pessoas = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibePessoaPage();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: pessoas.length,
        itemBuilder: (context, index) {
          return _listaPessoas(context, index);
        },
      ),
    );
  }

  _listaPessoas(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: pessoas[index].imagem != null
                          ? FileImage(File(pessoas[index].imagem))
                          : AssetImage('images/perfil.png')),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(pessoas[index].nome ?? '',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    Text(pessoas[index].latitude ?? '',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    Text(pessoas[index].longitude ?? '',
                        style: TextStyle(
                          fontSize: 20,
                        ))
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _confirmaExclusao(context, pessoas[index].id, index);
                },
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _exibePessoaPage(pessoa: pessoas[index]);
      },
    );
  }

  void _exibePessoaPage({Pessoa pessoa}) async {
    final pessoaRecebida = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PessoaPage(
                  pessoa: pessoa,
                )));

    if (pessoaRecebida != null) {
      if (pessoa != null) {
        await db.updatePessoa(pessoaRecebida);
      } else {
        await db.insertPessoa(pessoaRecebida);
      }
      _exibeTodasPessoas();
    }
  }

  void _confirmaExclusao(BuildContext context, int pessoaid, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Pessoa'),
          content: Text('Confirmar exclusão da Pessoa'),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text('Cancelar')),
            FlatButton(
              child: Text('Excluir'),
              onPressed: () {
                setState(() {
                  pessoas.removeAt(index);
                  db.deletePessoa(pessoaid);
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
