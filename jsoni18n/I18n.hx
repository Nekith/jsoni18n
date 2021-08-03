package jsoni18n;

import haxe.Json;

class I18n {
	public var depthDelimiter:String = "/";
	public var varPrefix:String = ":";
	public var pluralizationVar:String = "_";
	public var concordVar:String = '$';

	private var trads:DynamicObject<Dynamic>;

	public function new() {
		trads = new DynamicObject<Dynamic>();
	}

	public function loadFromString(content:String, ?prefix:String):Void {
		var data:DynamicObject<Dynamic> = Json.parse(content);
		for (key in data.keys()) {
			var name:String = key;
			if (prefix != null) {
				name = prefix + name;
			}
			update(trads, name, data.get(key));
		}
	}

	public function tr(id:String, ?vars:Map<String, Dynamic>):String {
		var o:DynamicObject<Dynamic> = fetch(trads, new String(id));
		if (o == null)
			return id;
		var str = handle(o, vars);
		if (str == null) {
			return id;
		}
		if (vars != null) {
			for (key in vars.keys()) {
				str = StringTools.replace(str, varPrefix + key, Std.string(vars[key]));
			}
		}
		return str;
	}

	public function clear():Void {
		trads = new DynamicObject<Dynamic>();
	}

	private function update(el:DynamicObject<Dynamic>, rest:String, data:DynamicObject<Dynamic>):Void {
		var pos:Int = rest.indexOf(depthDelimiter);
		if (pos == -1) {
			if (el.exists(rest) == true) {
				el = el.get(rest);
				for (key in data.keys()) {
					el.set(key, data.get(key));
				}
			} else {
				el.set(rest, data);
			}
		} else {
			var part:String = rest.substr(0, pos);
			rest = rest.substr(pos + 1);
			var sub:DynamicObject<Dynamic>;
			if (el.exists(part) == false) {
				sub = new DynamicObject<Dynamic>();
				el.set(part, sub);
			} else {
				sub = el.get(part);
			}
			update(sub, rest, data);
		}
	}

	private function fetch(el:DynamicObject<Dynamic>, rest:String):DynamicObject<Dynamic> {
		var pos:Int = rest.indexOf(depthDelimiter);
		if (pos == -1) {
			return el.get(rest);
		}
		var part:String = rest.substr(0, pos);
		rest = rest.substr(pos + 1);
		if (el.exists(part) == false) {
			return null;
		}
		return fetch(el.get(part), rest);
	}

	private function handle(o:DynamicObject<Dynamic>, ?vars:Map<String, Dynamic>):Null<String> {
		var change = false;
		if (vars == null) {
			if (Std.isOfType(o, String)) {
				return cast(o, String);
			}
			return null;
		}
		if (vars.exists(pluralizationVar) && o.exists(pluralizationVar)) {
			var n:Null<Int> = vars[pluralizationVar];
			if (n != null) {
				if (n == 0 && o.exists("0")) {
					o = o.get("0");
					change = true;
				} else if (n == 1 && o.exists("1")) {
					o = o.get("1");
					change = true;
				} else {
					o = o.get(pluralizationVar);
					change = true;
				}
			}
		} else if (vars.exists(concordVar) && o.exists(concordVar)) {
			var c:Null<String> = vars[concordVar];
			if (c != null) {
				if (o.exists(c)) {
					o = o.get(c);
					change = true;
				} else {
					o = o.get(concordVar);
					change = true;
				}
			}
		}
		if (Std.isOfType(o, String)) {
			return cast(o, String);
		}
		if (change == false) {
			return null;
		}
		return handle(o, vars);
	}
}

abstract DynamicObject<T>(Dynamic<T>) from Dynamic<T> {
	public inline function new() {
		this = {};
	}

	public inline function set(key:String, value:T):Void {
		Reflect.setField(this, key, value);
	}

	public inline function get(key:String):Null<T> {
		return Reflect.field(this, key);
	}

	public inline function exists(key:String):Bool {
		return Reflect.hasField(this, key);
	}

	public inline function keys():Array<String> {
		return Reflect.fields(this);
	}
}
