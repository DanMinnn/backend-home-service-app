package com.danmin.home_service.config;

import java.math.BigDecimal;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.stereotype.Component;

@Component
public class GeometryHelper {
    private final GeometryFactory geometryFactory;

    public GeometryHelper() {
        this.geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
    }

    public Point createPoint(BigDecimal latitude, BigDecimal longitude) {
        return geometryFactory.createPoint(
                new Coordinate(longitude.doubleValue(), latitude.doubleValue()));
    }
}
