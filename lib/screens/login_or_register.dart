import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examen_final_mendoza/providers/login_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  @override
  _LoginOrRegisterScreenState createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  GlobalKey<FormState> _key = GlobalKey();

  RegExp emailRegExp =
      new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');
  RegExp contRegExp = new RegExp (r'^([0-9a-zA-Z@.\s]{1,255})$');

  String? _correu;
  String? _passwd;
  String missatge = '';
  String errorCode = '';
  bool _isChecked = false;

  late var loginProvider;

  initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    //Descomentar las siguientes lineas para generar un efecto de "respiracion"
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginProvider = Provider.of<LoginProvider>(context);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              child: AnimatedLogo(animation: animation),
            ),
            if (loginProvider.isLoginOrRegister) loginOrRegisterForm(),
            SizedBox(height: 100),
            loginOrRegisterButtons()
          ],
        ),
      ),
    );
  }

  Widget loginOrRegisterButtons() {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        loginProvider.opcioMenu(index);
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.blue[800],
      selectedColor: Colors.white,
      fillColor: Colors.blue[200],
      color: Colors.blue[400],
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 120.0,
      ),
      isSelected: loginProvider.selectedEvent,
      children: events,
    );
  }

  Widget loginOrRegisterForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(loginProvider.isLogin ? 'Inicia sessió' : 'Registra\'t'),
        Container(
          width: 300.0,
          child: Form(
            key: _key,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: '',
                  validator: (text) {
                    if (text!.length == 0) {
                      return "Correu es obligatori";
                    } else if (!emailRegExp.hasMatch(text)) {
                      return "Format correu incorrecte";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Escrigui el seu correu',
                    labelText: 'Correu',
                    counterText: '',
                    icon:
                        Icon(Icons.email, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _correu = text,
                ),
                TextFormField(
                  initialValue: '',
                  validator: (text) {
                    if (text!.length == 0) {
                      return "Contrasenya és obligatori";
                    } else if (text.length <= 5) {
                      return "Contrasenya mínim de 5 caràcters";
                    } else if (!contRegExp.hasMatch(text)) {
                      return "Contrasenya incorrecte";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: 'Escrigui la contrasenya',
                    labelText: 'Contrasenya',
                    counterText: '',
                    icon: Icon(Icons.lock, size: 32.0, color: Colors.blue[800]),
                  ),
                  onSaved: (text) => _passwd = text,
                ),
                loginProvider.isLogin
                    ? CheckboxListTile(
                        value: _isChecked,
                        onChanged: (value) {
                          _isChecked = value!;
                          setState(() {});
                        },
                        title: Text('Recorda\'m'),
                        controlAffinity: ListTileControlAffinity.leading,
                      )
                    : SizedBox(height: 56),
                IconButton(
                  onPressed: () => _loginRegisterRequest(),
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 42.0,
                    color: Colors.blue[800],
                  ),
                ),
                loginProvider.isLoading
                    ? CircularProgressIndicator()
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _loginRegisterRequest() async {
  if (_key.currentState!.validate()) {
    _key.currentState!.save();
    // Aquí es donde se hace la petición de login
    await loginProvider.loginOrRegister(_correu, _passwd);

    if (loginProvider.accesGranted) {
      // Mostrar un SnackBar de éxito después del login
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('¡Login exitoso! Bienvenido, $_correu'),
        duration: Duration(seconds: 2), // Duración del SnackBar
      ));

      // Guardar las credenciales si "Recordarme" está activado
      if (_isChecked) {
        saveUserCredentials(_correu!, _passwd!, _isChecked);
      }

      // Redirigir a la pantalla principal
      Navigator.of(context).pushReplacementNamed('home');
    } else {
      // Si no se concedió acceso, mostrar el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(loginProvider.errorMessage),
      ));
    }
  }
}


  void saveUserCredentials(String email, String password, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', rememberMe);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }
}

class AnimatedLogo extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);
  static final _sizeTween = Tween<double>(begin: 0.0, end: 100.0);

  AnimatedLogo({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: _sizeTween.evaluate(animation), // Aumenta la altura
        width: _sizeTween.evaluate(animation), // Aumenta el ancho
        child: FlutterLogo(),
      ),
    );
  }
}

const List<Widget> events = <Widget>[
  Text('Inicia sessió'),
  Text('Registra\'t'),
];
