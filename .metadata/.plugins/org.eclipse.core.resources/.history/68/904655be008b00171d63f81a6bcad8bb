/*
 * Copyright 1997-2009 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */
package com.day.cq.wcm.foundation.forms;

import java.lang.reflect.Array;
import java.util.*;

import org.apache.commons.lang.ObjectUtils;
import org.apache.jackrabbit.util.ISO8601;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ValueMap;

/**
 * {@linkplain MergedValueMap} merges the values of the value maps from multiple
 * resources. It merges the values of all value maps behind the resources, ie.
 * provides a null value for a key if the value is not the same in all resources
 * and only presents a value if that one is present in exactly all of the
 * resources.
 * 
 * <p>
 * It is optimized for the forms module, ie. on calls to
 * {@link #get(String, Class)} with <code>String[]</code> as type (see
 * {@link FormsHelper#getValues(org.apache.sling.api.SlingHttpServletRequest, Resource)}
 * ).
 * 
 * <p>
 * Note: this class is not synchronized, ie. not thread-safe.
 * 
 */
public class MergedValueMap implements ValueMap {

    private List<Resource> resources;

    private Map<String, Object> cache;
    
    public MergedValueMap(List<Resource> resources) {
        this.resources = resources;
    }
    
    protected void readFully() {
        if (cache == null) {
            cache = fetchAndMergeAllValues();
        }
    }
    
    protected Map<String, Object> fetchAndMergeAllValues() {
        Map<String, Object> mergedMap = new HashMap<String, Object>();
        
        boolean firstResource = true;
        for (Resource resource : resources) {
            ValueMap map = resource.adaptTo(ValueMap.class);
            if (map != null) {
                for (Entry<String, Object> entry : map.entrySet()) {
                    String key = entry.getKey();
                    if (mergedMap.containsKey(key)) {
                        // key was in a previous resource already
                        Object value = mergedMap.get(key);
                        if (value == null) {
                            // values were already different before, keep null
                        } else {
                            Object newValue = entry.getValue();
                            if (newValue != null && value.equals(newValue)) {
                                // same value as before, keep it in the cache
                            } else {
                                // different values found, store null
                                mergedMap.put(key, null);
                            }
                        }
                    } else {
                        // first access to this key
                        if (firstResource) {
                            // first resource, store current value
                            mergedMap.put(key, entry.getValue());
                        } else {
                            // new key, wasn't present in previous resources
                            mergedMap.put(key, null);
                        }
                    }
                }
            }
            firstResource = false;
        }
        
        return mergedMap;
    }

    public Object get(Object key) {
        readFully();
        Object value = cache.get(key);
        if (value == null) {
            value = read((String) key);
        }
        return value;
    }

    private Object read(String key) {
        Object value = null;
        boolean firstResource = true;
        boolean isArray = false;
        for (Resource resource : resources) {
            ValueMap map = resource.adaptTo(ValueMap.class);
            if (map != null) {
                if (firstResource) {
                    value = map.get(key);
                    if (value == null) break;
                    isArray = value.getClass().isArray();
                } else {
                    Object newValue = map.get(key);
                    if (newValue == null) {
                        value = null;
                        break;
                    }
                    boolean newIsArray = newValue.getClass().isArray();
                    if (isArray != newIsArray ||
                        (isArray && !Arrays.equals((Object[]) value, (Object[]) newValue)) ||
                        (!isArray && !ObjectUtils.equals(value, newValue))) {

                        // break if:
                        // - one of the values is single and the other mutiple
                        // - or both are mutliple but the values do not match
                        // - or both are single but do not match
                        value = null;
                        break;
                    }
                }
            }
            firstResource = false;
        }
        cache.put(key, value);
        return value;
    }

    @SuppressWarnings("unchecked")
    public <T> T get(String name, Class<T> type) {
        readFully();
        if (type == null) {
            return (T) get(name);
        }

        return convert(get(name), type);
    }

    @SuppressWarnings("unchecked")
    public <T> T get(String name, T defaultValue) {
        readFully();
        T value = get(name, (Class<T>) defaultValue.getClass());
        return value == null ? defaultValue : value;
    }

    public int size() {
        readFully();
        return cache.size();
    }

    public boolean isEmpty() {
        return size() == 0;
    }

    public boolean containsKey(Object key) {
        readFully();
        return cache.containsKey(key);
    }

    public boolean containsValue(Object value) {
        readFully();
        return cache.containsValue(value);
    }

    public Set<java.util.Map.Entry<String, Object>> entrySet() {
        readFully();
        return cache.entrySet();
    }

    public Set<String> keySet() {
        readFully();
        return cache.keySet();
    }

    public Collection<Object> values() {
        readFully();
        return cache.values();
    }

    // ---------- Type conversion helper
    
    /**
     * Converts the object to the given type.
     * @param obj object
     * @param type type
     * @return the converted object
     */
    @SuppressWarnings("unchecked")
    private <T> T convert(Object obj, Class<T> type) {
        try {
            if (obj == null) {
                return null;
            } else if (type.isAssignableFrom(obj.getClass())) {
                return (T) obj;
            } else if (type.isArray()) {
                return (T) convertToArray(obj, type.getComponentType());
            } else if (obj instanceof Calendar && type == String.class) {
                // simulate jcrValue.getString()
                return (T) ISO8601.format((Calendar) obj);
            } else if (type == String.class) {
                return (T) String.valueOf(obj);
            } else if (type == Integer.class) {
                return (T) (Integer) Integer.parseInt(obj.toString());
            } else if (type == Long.class) {
                return (T) (Long) Long.parseLong(obj.toString());
            } else if (type == Double.class) {
                return (T) (Double) Double.parseDouble(obj.toString());
            } else if (type == Boolean.class) {
                return (T) (Boolean) Boolean.parseBoolean(obj.toString());
            } else {
                return null;
            }
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * Converts the object to an array of the given type
     * @param obj tje object or object array
     * @param type the component type of the array
     * @return and array of type T
     */
    private <T> T[] convertToArray(Object obj, Class<T> type) {
        List<T> values = new LinkedList<T>();
        if (obj.getClass().isArray()) {
            for (Object o: (Object[]) obj) {
                values.add(convert(o, type));
            }
        } else {
            values.add(convert(obj, type));
        }
        @SuppressWarnings("unchecked")
        T[] result = (T[]) Array.newInstance(type, values.size());
        return values.toArray(result);
    }

    // ---------- Unsupported Modification methods

    public void clear() {
        throw new UnsupportedOperationException();
    }

    public Object put(String key, Object value) {
        throw new UnsupportedOperationException();
    }

    public void putAll(Map<? extends String, ? extends Object> t) {
        throw new UnsupportedOperationException();
    }

    public Object remove(Object key) {
        throw new UnsupportedOperationException();
    }

}
