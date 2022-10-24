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
/*
 * object linea1{
	method image() = 'vacio.png'
	method position() = game.at(9,2)
	method text() = '
	Bienvenido a la Batalla!!! Elige tu pokemon...'
	}
 	
 */

object opcion1{
	method image() = 'vacio.png'
	method position() = game.at(6,2)
	method text() = '
1 - '+textos.textoMovimientoTr1(0)
}

object opcion2{
	method image() = 'vacio.png'
	method position() = game.at(9,2)
	method text() = '
2 - '+textos.textoMovimientoTr1(1)
}

object opcion3{
	method image() = 'vacio.png'
	method position() = game.at(12,2)
	method text() = '
3 - '+textos.textoMovimientoTr1(2)
}

object opcion4{
	method image() = 'vacio.png'
	method position() = game.at(15,2)
	method text() = '
4 - '+textos.textoMovimientoTr1(3)
}


object truchimon1{
	method image()='vacio.png'
	method position()=game.at(6,1)
	method text()='Q - '+textos.textoTruchimon(0)
}

object truchimon2{
	method image()='vacio.png'
	method position()=game.at(9,1)
	method text()='W - '+textos.textoTruchimon(1)
}

object truchimon3{
	method image()='vacio.png'
	method position()=game.at(12,1)
	method text()='E - '+textos.textoTruchimon(2)
}

object truchimon4{
	method image()='vacio.png'
	method position()=game.at(15,1)
	method text()='R - '+textos.textoTruchimon(3)
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
	method text() = textos.vidaTruchiBueno()
}

object cora2{
	method image() = 'heart.png'
	method position() = game.at(23,13)
}

object vidaOponente{
	method image() = 'vacio.png'
	method position() = game.at(22,13)
	method text() = textos.vidaTruchiMalo()
}

object half{
	method image() = 'half.png'
}

object nombreNuestro{
	method image() = 'vacio.png'
	method position()=game.at(1,13)
	method text()= textos.nombreTruchiBueno()
}

object nombreMalo{
	method image() = 'vacio.png'
	method position()=game.at(19,13)
	method text()= textos.nombreTruchiMalo()
}


object instrucciones{
	method image()='vacio.png'
	method position()=game.at(0,0)
	method text()=
	'INSTRUCCIONES: Del 1-4 son los ataques que sabe tu truchimon, con Q,W,E,R podes cambiar de truchimon. Cagalo a palos al otro y gana!!'
}





object textos{
	
	var property nombreTruchiBueno = ''
	var property nombreTruchiMalo = ''
	var property vidaTruchiBueno = ''
	var property vidaTruchiMalo = ''
	
	
	
	method iniciarTextosBueno(truchi){
		nombreTruchiBueno = '\n'+truchi.nombre()
		vidaTruchiBueno = '\n'+truchi.salud().toString()+' / '+truchi.saludMaxima().toString()
	}
	
	method iniciarTextosMalo(truchi){
		nombreTruchiMalo = '\n'+truchi.nombre()
		vidaTruchiMalo = '\n'+truchi.salud().toString()+' / '+truchi.saludMaxima().toString()
	}
	
	method actualizarTextosBueno(truchi){
		nombreTruchiBueno = '\n'+truchi.nombre()
		vidaTruchiBueno =  '\n'+truchi.salud().toString()+' / '+truchi.saludMaxima().toString()
	}
	
	method actualizarTextosMalo(truchi){
		nombreTruchiMalo = '\n'+truchi.nombre()
		vidaTruchiMalo =  '\n'+truchi.salud().toString()+' / '+truchi.saludMaxima().toString()
	}
	
	method textoMovimientoTr1(indice){
		return if(batalla.tr1().tieneEsteAtaque(indice)) batalla.tr1().movimientos().get(indice).nombre() else ''
	}
	
	method textoTruchimon(indice){
		return if(entrenador.tieneEsteTruchi(indice)) entrenador.truchimones().get(indice).nombre() else ''
	}
	
}



object batalla {
	var property estatus = 5
	var turno = 0
	var mov = null
	var property tr1 = entrenador.truchimonEnUso() //Cuando pase la pelea, vamos a setarlos en base a lo que decidamos
	//var property tr2 = mikali
	//var property tr1 = entrenador.pokemones().first()
	
	var property entrenadorEnemigo = null
	var property tr2 = null
	
	
	
	
	method seleccionTruchiEnemigo(indice){
		tr2 = entrenadorEnemigo.truchimones().get(indice)
	}
	
	method estadoT() = tr1.estado()
	
	method empezar(enemigoo){
		entrenadorEnemigo = enemigoo
		self.seleccionTruchiEnemigo(0)
		self.iniciar()
	}
	
	method iniciar(){
		textos.iniciarTextosBueno(tr1)
		textos.iniciarTextosMalo(tr2)
		
		game.width(24)
		game.height(14)
		game.addVisual(fondobatalla)
		game.addVisual(cuadroDialogo)
		//game.addVisual(linea1)
		game.addVisual(opcion1)
		game.addVisual(opcion2)
		game.addVisual(opcion3)
		game.addVisual(opcion4)
		game.addVisual(truchimon1)
		game.addVisual(truchimon2)
		game.addVisual(truchimon3)
		game.addVisual(truchimon4)
		
		
		game.addVisual(stats)
		game.addVisual(stats2)
		game.addVisual(cora1)
		game.addVisual(nombreNuestro)
		game.addVisual(cora2)
		game.addVisual(nombreMalo)
		game.addVisual(vidaNuestra)
		game.addVisual(vidaOponente)
		
		tr1.position(game.at(6,4))
		tr2.position(game.at(13,7))
		game.addVisual(tr1)
		game.addVisual(tr2)
		
		keyboard.enter().onPressDo({self.pelea(tr1,tr2)})
		keyboard.num1().onPressDo{self.nuestroTurno(tr1,tr2,0)}
		keyboard.num2().onPressDo{self.nuestroTurno(tr1,tr2,1)}
		keyboard.num3().onPressDo{self.nuestroTurno(tr1,tr2,2)}
		keyboard.num4().onPressDo{self.nuestroTurno(tr1,tr2,3)}
		keyboard.q().onPressDo{self.actualizarTruchiEnUso(0)}
		keyboard.w().onPressDo{self.actualizarTruchiEnUso(1)}
		keyboard.e().onPressDo{self.actualizarTruchiEnUso(2)}
		keyboard.r().onPressDo{self.actualizarTruchiEnUso(3)}
		
		
		//Para la captura, en el metodo captura del entrenador, llamar a batalla.finBatalla()
		game.start()		
	}
	
	method actualizarTruchiEnUso(indice){
		if(entrenador.tieneEsteTruchi(indice) ){
			if(entrenador.puedeElegir(indice)){
				entrenador.elegirTruchimon(indice)
				if(tr1.murio()){
					self.actualizarImagenTr1()
					game.schedule(2000,{self.pelea(tr1,tr2)})
					
				}
				else{
					self.actualizarImagenTr1()
					turno +=1
					game.schedule(2000,{self.turnoPc(tr2,tr1)})
				}
				
			}
			else{
				game.say(tr1,'Para rey, ese necesita descansar, lo re cagaron a palos!!')
			}
			
		}
		else{
			game.say(tr1,'Para rey, no tenes tantos truchimones!!')
		}
		
		
		
	}
	
	method actualizarImagenTr1(){
		game.removeVisual(tr1)
		tr1 = entrenador.truchimonEnUso()
		tr1.position(game.at(6,4))
		game.schedule(500,{game.addVisual(tr1)})
		textos.actualizarTextosBueno(tr1)
	}
	
	
	method actualizarTruchiEnemigo(){
		entrenadorEnemigo.aumentarIndice()
		entrenadorEnemigo.elegirTruchimon()
		game.schedule(500,{self.actualizarImagenTr2()})
		game.schedule(2000,{self.turnoPc(tr2,tr1)})
		
		
	}
	
	method actualizarImagenTr2(){
		game.removeVisual(tr2)
		tr2 = entrenadorEnemigo.truchimonEnUso()
		tr2.position(game.at(13,7))
		game.schedule(500,{game.addVisual(tr2)})
		textos.actualizarTextosMalo(tr2)
		
	}
	
	
	method pelea(t1,t2){		
		if(turno%2==0){//Nuestro turno
			//Mostrar los ataques
			console.println('Nuestro turno')			
		} else {
			//mov es random para el otro
			game.schedule(2000,{self.turnoPc(t1,t2)})
			// OJO ESTO PUEDE ESTAR MAL TUVE QUE CORREGIRLO POR QUE ESTABA DUPLICADO.
		}		
	}
	
	method finBatalla(ganador){
		console.println('Fin Batalla, gano '+ganador.nombre()+'!!!')
		ganador.ganarXP()
		ganador.subeDeNivel()
		//jungla.iniciar() o coliseo, volver a donde estemos.
	}
	
	method terminoBatalla(){
		return entrenador.truchimones().all({truchi => truchi.murio()}) or entrenadorEnemigo.truchimones().all({truchi=>truchi.murio()})
	}
	
	method nuestroTurno(t1,t2,indecs){
		//console.println('Nuestro turno')
		
		if(not t1.murio()){
			if(t1.movimientos().size()>indecs){
				mov= t1.movimientos().get(indecs)
				turno+=1
				console.println('Elegimos '+ mov.nombre())
				
				console.println('La vida de '+t2.nombre()+' es de '+t2.salud().toString())
				t1.atacar(t2,mov)
				game.say(t1,'Te ataco con '+mov.nombre())
				
				textos.actualizarTextosMalo(t2)
				console.println('La vida de '+t2.nombre()+' es de '+t2.salud().toString())
				
				if(not t2.murio()){
					game.schedule(2000,{self.pelea(t2,t1)})
				} 
				else {
					if(entrenadorEnemigo.puedeSeguir()){
						game.say(t2,'No doy mas!!')
						self.actualizarTruchiEnemigo()
						game.schedule(2000,{self.pelea(t2,t1)})
					}
					else{
						game.say(t2,'NOOO PERDIMOS!!!')
						game.schedule(2000,{self.finBatalla(t1)})
					}	
				}
			}
			else{
				game.say(t1,'No tengo tantos movimientos!!')
			}
		}
		else{
			game.say(t1,'Rey no puedo atacar, no doy mas!!')
		}
		
				
	}
	
	method turnoPc(t2,t1){
		mov=t2.movimientos().anyOne()
		turno+=1
		
		console.println('Turno de '+t2.nombre())
		
		console.println('Eligio '+mov.nombre())
		game.say(t2,'Te ataco con '+ mov.nombre())
		
		console.println('La vida de '+t1.nombre()+' es de '+t1.salud().toString())
		t2.atacar(t1,mov)
		textos.actualizarTextosBueno(t1)
		console.println('La vida de '+t1.nombre()+' es de '+t1.salud().toString())
		
		if(not t1.murio()){
			game.schedule(2000,{self.pelea(t1,t2)})
			
		} else {
			if(entrenador.puedeSeguir()){
				game.say(t1,'No doy mas rey, cambiame por otro!!')
			}
			else{
				game.say(t1,'NOOO PERDIMOS!!!')
				game.schedule(2000,{self.finBatalla(t2)})
			}
			
			
		}
	}
	
	
		
}
