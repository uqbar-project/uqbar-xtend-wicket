package org.uqbar.wicket.xtend

import java.util.List
import org.apache.wicket.markup.html.list.ListItem
import org.apache.wicket.markup.html.list.ListView
import org.apache.wicket.model.IModel
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1

/**
 * Extends wicket's {@link ListView} to adapt it
 * to use xtend's closures.
 * By introducing composition instead of inheritance.
 * 
 * @author jfernandes
 */
@Accessors
class XListView<T> extends ListView<T> {
	Procedure1<ListItem<T>> populateItem

	new(String id) { super(id)	}
	new(String id, IModel<? extends List<? extends T>> model) { super(id, model) }
	new(String id, List<? extends T> list) { super(id, list) }

	override populateItem(ListItem<T> item) {
		populateItem.apply(item)
	}
	
}