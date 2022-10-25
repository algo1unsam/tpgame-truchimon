import wollok.mirror.*

class Prueba {
	var property vida = []
	var property vidon = [new Test( nombre = 'cambilo'),new Test( nombre='paraloga')]
	var property vidados = []
	
	
	method initialize(){
		vida.addAll([new Test(nombre = 'camilo'),new Test(nombre = 'pocho'),new Test(nombre = 'rosario')])
	}	
	
	method copiar(){
		self.initialize()
	}
}

class Test {
	var property nombre
}
