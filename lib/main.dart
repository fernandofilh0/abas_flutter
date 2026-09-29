import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'App com Abas',
      debugShowCheckedModeBanner: false,
      home: AbasPage(),
    );
  }
}


class AbaInfo {
  final String titulo;
  final IconData icone;
  final Color cor;
  const AbaInfo(this.titulo, this.icone, this.cor);
}

const List<AbaInfo> abas = [
  AbaInfo('Início', Icons.home, Colors.blue),
  AbaInfo('Notícias', Icons.newspaper, Colors.green),
  AbaInfo('Perfil', Icons.person, Colors.deepOrange),
];

class AbasPage extends StatefulWidget {
  const AbasPage({super.key});

  @override
  State<AbasPage> createState() => _AbasPageState();
}

class _AbasPageState extends State<AbasPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: abas.length, vsync: this);
    
    _controller.addListener(() {
      if (!_controller.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final corAtual = abas[_controller.index].cor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App com Abas'),
        backgroundColor: corAtual,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _controller,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            for (final aba in abas) Tab(icon: Icon(aba.icone), text: aba.titulo),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          InicioScreen(),
          NoticiasScreen(),
          PerfilScreen(),
        ],
      ),
    );
  }
}
 
class ImagemRede extends StatelessWidget {
  final String url;
  final double tamanho;
  final Color cor;
  final IconData iconeFallback;
  final bool circular;

  const ImagemRede({
    super.key,
    required this.url,
    required this.tamanho,
    required this.cor,
    required this.iconeFallback,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    final imagem = Image.network(
      url,
      width: tamanho,
      height: tamanho,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          width: tamanho,
          height: tamanho,
          child: Center(child: CircularProgressIndicator(color: cor)),
        );
      },
      errorBuilder: (context, error, stack) => Container(
        width: tamanho,
        height: tamanho,
        color: cor.withOpacity(0.15),
        child: Icon(iconeFallback, size: tamanho / 2, color: cor),
      ),
    );

    return circular
        ? ClipOval(child: imagem)
        : ClipRRect(borderRadius: BorderRadius.circular(16), child: imagem);
  }
}


class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const cor = Colors.blue;
    return Container(
      color: cor.withOpacity(0.08),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Seja bem-vindo(a)!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Explore as abas para navegar pelo app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ImagemRede(
              url: 'https://picsum.photos/id/1015/600/400',
              tamanho: 260,
              cor: cor,
              iconeFallback: Icons.image,
            ),
          ],
        ),
      ),
    );
  }
}


class NoticiasScreen extends StatelessWidget {
  const NoticiasScreen({super.key});

  static const List<String> manchetes = [
    'Cientistas descobrem novo tipo de flor que brilha no escuro',
    'Cidade inaugura primeira ciclovia totalmente solar',
    'Aplicativo de estudos alcança um milhão de downloads',
    'Time local vence campeonato após virada histórica',
    'Feira de tecnologia apresenta robô que ajuda na colheita',
    'Biblioteca pública lança programa de leitura para jovens',
  ];

  @override
  Widget build(BuildContext context) {
    const cor = Colors.green;
    return Container(
      color: cor.withOpacity(0.08),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: manchetes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: cor,
                foregroundColor: Colors.white,
                child: Text('${index + 1}'),
              ),
              title: Text(
                manchetes[index],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Notícia fictícia'),
              trailing: const Icon(Icons.chevron_right, color: cor),
            ),
          );
        },
      ),
    );
  }
}


class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const cor = Colors.deepOrange;
    return Container(
      color: cor.withOpacity(0.08),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImagemRede(
              url: 'https://picsum.photos/id/64/300/300',
              tamanho: 160,
              cor: cor,
              iconeFallback: Icons.person,
              circular: true,
            ),
            SizedBox(height: 20),
            Text(
              'Maria da Silva',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Estudante de Sistemas de Informação',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}