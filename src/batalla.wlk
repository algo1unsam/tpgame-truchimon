import wollok.game.*
import truchimones.*
import entrenador.*

object fondobatalla{
	method image() = 'battle.png'
	method position() = game.origin()
}

object cuadroDialogo {
	method image() = 'emptyframe.png'
	method position() = game.at(5,0)
}

object linea1{
	method image() = 'vacio.png'
	method position() = game.at(9,2)
	method text() = '
Bienvenido a la Batalla!!! Elige tu pokemon...'
}

object opcion1{
	method image() = 'vacio.png'
	method position() = game.at(6,1)
	method text() = '
1 - '//+entrenador.pokemones.get(0)
}
object opcion2{
	method image() = 'vacio.png'
	method position() = game.at(9,1)
	method text() = '
2 - '//+entrenador.pokemones.get(1)
}
object opcion3{
	method image() = 'vacio.png'
	method position() = game.at(12,1)
	method text() = '
3 - '//+entrenador.pokemones.get(2)
}
object opcion4{
	method image() = 'vacio.png'
	method position() = game.at(15,1)
	method text() = '
4 - '//+entrenador.pokemones.get(3)
}

object stats{
	method image() = 'stats.png'
}
object stats2{
	method image() = 'stats.png'
}

object i1{
	method image() = 'heart.png'
}
object i2{
	method image() = 'heart.png'
}
object i3{
	method image() = 'heart.png'
}
object i4{
	method image() = 'heart.png'
}

object d1{
	method image() = 'heart.png'
}
object d2{
	method image() = 'heart.png'
}
object d3{
	method image() = 'heart.png'
}
object d4{
	method image() = 'heart.png'
}

object half{
	method image() = 'half.png'
}

object batalla {
	var property estatus = 5
	var turno = 0
	var indice = 0
	var mov = null
	//var property tr1= verguigneo //entrenador.truchimonElegido() //Cuando pase la pelea, vamos a setarlos en base a lo que decidamos
	//var property tr2= bulbasaur
	method iniciar(tr1,tr2){

		game.width(24)
		game.height(14)
		game.addVisual(fondobatalla)
		game.addVisual(cuadroDialogo)
		game.addVisual(linea1)
		game.addVisual(opcion1)
		game.addVisual(opcion2)
		game.addVisual(opcion3)
		game.addVisual(opcion4)
		
		game.addVisualIn(stats,game.at(0,12))
		game.addVisualIn(stats2,game.at(18,12))
		game.addVisualIn(i1,game.at(2,13))
		game.addVisualIn(i2,game.at(3,13))
		game.addVisualIn(i3,game.at(4,13))
		game.addVisualIn(i4,game.at(5,13))
		
		game.addVisualIn(d1,game.at(20,13))
		game.addVisualIn(d2,game.at(21,13))
		game.addVisualIn(d3,game.at(22,13))
		game.addVisualIn(d4,game.at(23,13))
		
		
		//Poner opcion de querer luchar. Con otro onPressDo
		keyboard.enter().onPressDo({self.pelea(tr1,tr2)})
		keyboard.num1().onPressDo{self.nuestroTurno(tr1,tr2,0)}
		keyboard.num2().onPressDo{self.nuestroTurno(tr1,tr2,1)}
		keyboard.num3().onPressDo{self.nuestroTurno(tr1,tr2,2)}
		keyboard.num4().onPressDo{self.nuestroTurno(tr1,tr2,3)}
		game.start()
		
		
		
		
	}
	
	method pelea(tr1,tr2){
		
		if(turno%2==0){//Nuestro turno
			//Mostrar los ataques
			console.println('Nuestro turno')
			
		}
		else{
			//mov es random para el otro
			self.turnoPc(tr2,tr1)
		}
		
		
	}
	method finBatalla(ganador){
		console.println('Fin Batalla, gano '+ganador.nombre()+'!!!')
		ganador.ganarXP()
		ganador.subeDeNivel()
		//jungla.iniciar() o coliseo, volver a donde estemos.
	}
	
	method nuestroTurno(t1,t2,indecs){
		//console.println('Nuestro turno')
		mov= t1.movimientos().get(indecs)
		turno+=1
		console.println('Elegimos '+mov.nombre())
		
		console.println('La vida de '+t2.nombre()+' es de '+t2.salud().toString())
		t1.atacar(t2,mov)
		console.println('La vida de '+t2.nombre()+' es de '+t2.salud().toString())
		
		if(not t2.murio()){
			self.pelea(t2,t1)
		}
		else{self.finBatalla(t1)}
		
	}
	
	method turnoPc(t2,t1){
		mov=t2.movimientos().anyOne()
		turno+=1
		
		console.println('Turno de '+t2.nombre())
		
		console.println('Eligio '+mov.nombre())
		
		console.println('La vida de '+t1.nombre()+' es de '+t1.salud().toString())
		t2.atacar(t1,mov)
		console.println('La vida de '+t1.nombre()+' es de '+t1.salud().toString())
		
		if(not t1.murio()){
			self.pelea(t1,t2)
		}
		else{self.finBatalla(t2)}
	}
	
	
	
	
	
	
}
