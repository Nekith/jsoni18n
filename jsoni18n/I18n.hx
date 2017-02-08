package jsoni18n;

import haxe.Json;

class I18n
{
    static public var depthDelimiter : String = "/";
    static public var varPrefix : String = ":";

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

    public static function tr(id : String, ?vars : Map<String, String>) : String
    {
        if (trads == null) {
            return "";
        }
        var str : String;
        if (id.indexOf(depthDelimiter) != -1) {
            str = fetch(trads, new String(id));
        } else if (trads.exists(id) == true) {
            str = trads.get(id);
        } else {
            str = id;
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

    private static function fetch(el : DynamicObject<Dynamic>, rest : String) : String
    {
        var pos : Int = rest.indexOf(depthDelimiter);
        if (pos == -1) {
            return el.get(rest);
        }
        var part : String = rest.substr(0, pos);
        rest = rest.substr(pos + 1);
        if (el.exists(part) == false) {
            return "";
        }
        return fetch(el.get(part), rest);
    }

    private static var trads : DynamicObject<Dynamic>;
}

abstract DynamicObject<T>(Dynamic<T>) from Dynamic<T>
{
    public inline function new()
    {
        this = {};
    }

    @:arrayAccess
    public inline function set(key : String, value : T) : Void
    {
        Reflect.setField(this, key, value);
    }

    @:arrayAccess
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
