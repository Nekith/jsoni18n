package jsoni18n;

import haxe.Json;

class I18n
{
    public static var depthDelimiter : String = "/";
    public static var varPrefix : String = ":";
    public static var pluralizationVar : String = "_";

    private static var trads : DynamicObject<Dynamic>;

    public static function loadFromString(content : String, ?prefix : String) : Void
    {
        if (trads == null) {
            trads = new DynamicObject<Dynamic>();
        }
        var data : DynamicObject<Dynamic> = Json.parse(content);
        for (key in data.keys()) {
            var name : String = key;
            if (prefix != null) {
                name = prefix + name;
            }
            update(trads, name, data.get(key));
        }
    }

    public static function tr(id : String, ?vars : Map<String, Dynamic>) : String
    {
        if (trads == null) {
            return id;
        }
        var str : String = id;
        if (id.indexOf(depthDelimiter) != -1) {
            var o : DynamicObject<Dynamic> = fetch(trads, new String(id));
            if (o != null) {
                if (Std.is(o, String)) {
                    str = Std.string(o);
                } else if (vars != null && vars.exists(pluralizationVar) && o.exists(pluralizationVar)) {
                    var n : Null<Int> = Std.parseInt(vars[pluralizationVar]);
                    if (n != null) {
                        if (n == 0 && o.exists("0")) {
                            str = o.get("0");
                        } else if (n == 1 && o.exists("1")) {
                            str = o.get("1");
                        } else if (o.exists(pluralizationVar)) {
                            str = o.get(pluralizationVar);
                        }
                    }
                }
            }
        } else if (trads.exists(id) == true) {
            str = trads.get(id);
        }
        if (vars != null) {
            for (key in vars.keys()) {
                str = StringTools.replace(str, varPrefix + key, vars[key]);
            }
        }
        return str;
    }

    public static function clear() : Void
    {
        trads = new DynamicObject<Dynamic>();
    }

    private static function update(el : DynamicObject<Dynamic>, rest : String, data : DynamicObject<Dynamic>) : Void
    {
        var pos : Int = rest.indexOf(depthDelimiter);
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
            var part : String = rest.substr(0, pos);
            rest = rest.substr(pos + 1);
            var sub : DynamicObject<Dynamic>;
            if (el.exists(part) == false) {
                sub = new DynamicObject<Dynamic>();
                el.set(part, sub);
            } else {
                sub = el.get(part);
            }
            update(sub, rest, data);
        }
    }

    private static function fetch(el : DynamicObject<Dynamic>, rest : String) : DynamicObject<Dynamic>
    {
        var pos : Int = rest.indexOf(depthDelimiter);
        if (pos == -1) {
            return el.get(rest);
        }
        var part : String = rest.substr(0, pos);
        rest = rest.substr(pos + 1);
        if (el.exists(part) == false) {
            return null;
        }
        return fetch(el.get(part), rest);
    }
}

abstract DynamicObject<T>(Dynamic<T>) from Dynamic<T>
{
    public inline function new()
    {
        this = {};
    }

    public inline function set(key : String, value : T) : Void
    {
        Reflect.setField(this, key, value);
    }

    public inline function get(key : String) : Null<T>
    {
        return Reflect.field(this, key);
    }

    public inline function exists(key : String) : Bool
    {
        return Reflect.hasField(this, key);
    }

    public inline function keys() : Array<String>
    {
        return Reflect.fields(this);
    }
}
