package org.uqbar.wicket.xtend

import java.lang.reflect.InvocationTargetException
import org.apache.wicket.Component
import org.apache.wicket.validation.IValidatable
import org.apache.wicket.validation.IValidator
import org.apache.wicket.validation.ValidationError
import org.apache.wicket.validation.validator.AbstractValidator
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.ReflectionUtils

/**
 * {@link IValidator} genérico que se puede utilizar para validar cualquier
 * propiedad. Para esto, se debe seguir una convención: 
 * 
 * Toda property podrá
 * - tener, además de un getter y un setter, un método público sin valor de
 * retorno (void) que reciba un único parámetro del mismo tipo que la property,
 * cuyo nombre comience con "validar" y siga con el nombre de la property con la
 * primer letra en mayúscula. dicha función deberá lanzar UserException en caso
 * en que el valor dado no cumpla con las reglas que definen la validez de los
 * valores de la property.
 * 
 * Ejemplos:
 * 
 * property "saldo" de tipo Double hace que busquemos 
 *     validarSaldo(Double saldo) 
 * 
 * property "edad" de tipo "Integer" nos lleva a 
 *     validarEdad(Integer edad) 
 * 
 * property "telefono" de tipo "String" nos lleva a 
 *     validarTelefono(String telefono)
 * 
 * @author jfernandes
 */
class PropertyValidator<T> extends AbstractValidator<T> {
	private Component component
	private String propertyName

	override bind(Component component) {
		this.component = component
		this.propertyName = component.getId()		
	}
	
	override onValidate(IValidatable<T> validatable) {
		try {
			val model = component.parent.defaultModelObject
			ReflectionUtils.invokeMethod(model,	validatePropertyMethodName, validatable.value)
		} 
		catch (RuntimeException e) {
			if (isUserException(e)) {
				val error = new ValidationError()
				error.message = e.cause.cause.message
				validatable.error(error)
			} else {
				throw e
			}
		}
	}
	
	def String getValidatePropertyMethodName() {
		return '''validar«Character.toUpperCase(propertyName.charAt(0))»«propertyName.substring(1)»'''
	}

	def isUserException(RuntimeException e) {
		e.cause instanceof InvocationTargetException && e.cause.cause instanceof UserException
	}

}