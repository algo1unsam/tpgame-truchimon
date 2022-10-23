import wollok.game.*
import truchimones.*
import entrenador.*

object fondobatalla{
	method image() = 'battle.png'
	method position() = game.origin()
}

object cuadroDialogo {
	method image() = 'cuadro.png'
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
	method position() = game.at(0,12)
}

object stats2{
	method image() = 'stats.png'
	method position() = game.at(18,12)
}

object cora1{
	method image() = 'heart.png'
	method position() = game.at(5,13)
}

object vidaNuestra{
	method image() = 'vacio.png'
	method position() = game.at(4,13)
	method text() = "\nhola"
}

object cora2{
	method image() = 'heart.png'
	method position() = game.at(23,13)
}

object cora2{
	method image() = 'heart.png'
	method position() = game.at(23,13)
}

object vidaOponente{
	method image() = 'vacio.png'
	method position() = game.at(22,13)
	method text() = "\nchau"
}

object half{
	method image() = 'half.png'
}

object batalla {
	var property estatus = 5
	var turno = 0
	var indice = 0
	var mov = null
	//var property tr1 = entrenador.truchimonElegido() //Cuando pase la pelea, vamos a setarlos en base a lo que decidamos
	//var property tr2 = mikali
	var property tr1 = verguigneo
	var property tr2 = mikali
	
	method iniciar(){

		game.width(24)
		game.height(14)
		game.addVisual(fondobatalla)
		game.addVisual(cuadroDialogo)
		game.addVisual(linea1)
		game.addVisual(opcion1)
		game.addVisual(opcion2)
		game.addVisual(opcion3)
		game.addVisual(opcion4)
		
		game.addVisual(stats)
		game.addVisual(stats2)
		game.addVisual(cora1)
		game.addVisual(cora2)
		game.addVisual(vidaNuestra)
		game.addVisual(vidaOponente)
		
		tr1.position(game.at(6,4))
		tr2.position(game.at(13,7))
		game.addVisual(tr1)
		game.addVisual(tr2)
		
		keyboard.enter().onPressDo({self.pelea(verguigneo,bulbasaur)})
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
