//Hacer que todas las naves se puedan preparar 
//para viajar. Esto hace que aumenten su velocidad 15.000 
//(teniendo la restricción de la velocidad máxima posible
//	de 300.000kms/s). Además de eso,

class Nave{
	var property velocidad = 0
	 
	method encontrarEnemigo(){
		self.recibirAmenaza()
		self.propulsar()	
	} 
	
	method recibirAmenaza()
	
	method aumentarVelocidad(cantidad){
		velocidad = 300000.min(velocidad + cantidad)
	}
	
	method propulsar(){
		self.aumentarVelocidad(20000)	
	}
	
	method preparar(){
		self.aumentarVelocidad(15000)
	}
}

class NaveDeCarga inherits Nave{
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}
}

class NaveDeCargaRadioactiva inherits NaveDeCarga{
	var estaSellada = false
	
	method estaSellada() = estaSellada
	
	override method velocidad(nueva){
		super(nueva)
		estaSellada = false
	}
	
	method sellarAlVacio(){
		velocidad = 0
		estaSellada = true
	}
	
	override method recibirAmenaza() {
		self.sellarAlVacio()
	}
	
	override method preparar(){
		self.sellarAlVacio()
		super()	
	}
}

class NaveDePasajeros inherits Nave{
	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}
}



class NaveDeCombate inherits Nave{
	var property modo = reposo
	var armasDesplegadas = false
	const property mensajesEmitidos = []
	
	method armasDesplegadas(){
		return armasDesplegadas	
	}

	method desplegarArmas(){
		armasDesplegadas = true	
	}
	
	method replegarArmas(){
		armasDesplegadas = false	
	}
		
	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = modo.invisible(self)

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}
	
	override method preparar(){
		modo.preparar(self)
		super()
		
	}
}

//las de combate, si se encuentran en modo ataque 
//emiten el mensaje "Volviendo a la base", 
//mientras que si están en reposo 
//emiten el mensaje "Saliendo en misión" 
//y se ponen en modo ataque.


class Modo{
	method recibirAmenaza(nave) {
		nave.emitirMensaje(self.mensajeAmenaza())
	}
	
	method mensajeAmenaza()
}

object reposo inherits Modo{
	method invisible(nave) {
		return nave.velocidad() < 10000 
	}
	
	override method mensajeAmenaza() {
		return "¡RETIRADA!"
	}
	
	method preparar(nave){
		nave.emitirMensaje("Saliendo en misión")
		nave.modo(ataque)
	}
}

object ataque inherits Modo {
	method invisible(nave) {
		return not nave.armasDesplegadas()
	}

	override method recibirAmenaza(nave) {
		super(nave)
		nave.desplegarArmas()
	}
	
	override method mensajeAmenaza() {
		return "Enemigo encontrado"
	}
	
	method preparar(nave){
		nave.emitirMensaje("Volviendo a la base")
	}
}

