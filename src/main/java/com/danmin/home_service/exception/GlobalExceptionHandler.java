package com.danmin.home_service.exception;

import java.util.Date;

import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;

import io.jsonwebtoken.JwtException;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.ConstraintViolationException;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler({ ConstraintViolationException.class,
            MissingServletRequestParameterException.class, MethodArgumentNotValidException.class })
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ApiResponses(value = {
            @ApiResponse(responseCode = "400", description = "Bad Request", content = {
                    @Content(mediaType = APPLICATION_JSON_VALUE, examples = @ExampleObject(name = "Handle exception when the data invalid. (@RequestBody, @RequestParam, @PathVariable)", summary = "Handle Bad Request", value = """
                            {
                                 "timestamp": "2024-04-07T11:38:56.368+00:00",
                                 "status": 400,
                                 "path": "/api/v1/...",
                                 "error": "Invalid Payload",
                                 "message": "{data} must be not blank"
                             }
                            """)) })
    })
    public ErrorResponse handleValidationException(Exception e, WebRequest request) {
        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setTimestamp(new Date());
        errorResponse.setStatus(HttpStatus.BAD_REQUEST.value());
        errorResponse.setPath(request.getDescription(false).replace("uri=", ""));

        String message = e.getMessage();
        if (e instanceof MethodArgumentNotValidException) {
            int start = message.lastIndexOf("[") + 1;
            int end = message.lastIndexOf("]") - 1;
            message = message.substring(start, end);
            errorResponse.setError("Invalid Payload");
            errorResponse.setMessage(message);
        } else if (e instanceof MissingServletRequestParameterException) {
            errorResponse.setError("Invalid Parameter");
            errorResponse.setMessage(message);
        } else if (e instanceof ConstraintViolationException) {
            errorResponse.setError("Invalid Parameter");
            errorResponse.setMessage(message.substring(message.indexOf(" ") + 1));
        } else {
            errorResponse.setError("Invalid Data");
            errorResponse.setMessage(message);
        }

        return errorResponse;
    }

    /**
     * Handle exception when the request not found data
     *
     * @param e
     * @param request
     * @return
     */
    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    @ApiResponses(value = {
            @ApiResponse(responseCode = "403", description = "FORBIDDEN", content = {
                    @Content(mediaType = APPLICATION_JSON_VALUE, examples = @ExampleObject(name = "403 Response", summary = "Handle exception when forbidden", value = """
                            {
                              "timestamp": "2023-10-19T06:07:35.321+00:00",
                              "status": 403,
                              "path": "/api/v1/...",
                              "error": "Forbidden",
                              "message": "{data} is forbidden"
                            }
                            """)) })
    })
    public ErrorResponse handleAccessDeniedException(AccessDeniedException e, WebRequest request) {
        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setTimestamp(new Date());
        errorResponse.setPath(request.getDescription(false).replace("uri=", ""));
        errorResponse.setStatus(HttpStatus.FORBIDDEN.value());
        errorResponse.setError(HttpStatus.FORBIDDEN.getReasonPhrase());
        errorResponse.setMessage(e.getMessage());

        return errorResponse;
    }

    /**
     * Handle exception when the request not found data
     *
     * @param e
     * @param request
     * @return
     */
    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    @ApiResponses(value = {
            @ApiResponse(responseCode = "404", description = "Bad Request", content = {
                    @Content(mediaType = APPLICATION_JSON_VALUE, examples = @ExampleObject(name = "404 Response", summary = "Handle exception when resource not found", value = """
                            {
                              "timestamp": "2023-10-19T06:07:35.321+00:00",
                              "status": 404,
                              "path": "/api/v1/...",
                              "error": "Not Found",
                              "message": "{data} not found"
                            }
                            """)) })
    })
    public ErrorResponse handleResourceNotFoundException(ResourceNotFoundException e, WebRequest request) {
        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setTimestamp(new Date());
        errorResponse.setPath(request.getDescription(false).replace("uri=", ""));
        errorResponse.setStatus(HttpStatus.NOT_FOUND.value());
        errorResponse.setError(HttpStatus.NOT_FOUND.getReasonPhrase());
        errorResponse.setMessage(e.getMessage());

        return errorResponse;
    }

    /**
     * Handle exception when the data is conflicted
     *
     * @param e
     * @param request
     * @return
     */
    @ExceptionHandler(InvalidDataException.class)
    @ResponseStatus(HttpStatus.OK)
    @ApiResponses(value = {
            @ApiResponse(responseCode = "400", description = "Invalid data", content = {
                    @Content(mediaType = APPLICATION_JSON_VALUE, examples = @ExampleObject(name = "400 Response", summary = "Handle exception when input data is invalid", value = """
                            {
                              "timestamp": "2023-10-19T06:07:35.321+00:00",
                              "status": 400,
                              "path": "/api/v1/...",
                              "error": "Invalid data",
                              "message": "{data} exists, Please try again!"
                            }
                            """)) })
    })
    public ErrorResponse handleDuplicateKeyException(InvalidDataException e, WebRequest request) {
        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setTimestamp(new Date());
        errorResponse.setPath(request.getDescription(false).replace("uri=", ""));
        errorResponse.setStatus(HttpStatus.BAD_REQUEST.value());
        errorResponse.setError(HttpStatus.BAD_REQUEST.getReasonPhrase());
        errorResponse.setMessage(e.getMessage());

        return errorResponse;
    }

    /**
     * Handle exception when internal server error
     *
     * @param e
     * @param request
     * @return error
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ApiResponses(value = {
            @ApiResponse(responseCode = "500", description = "Internal Server Error", content = {
                    @Content(mediaType = APPLICATION_JSON_VALUE, examples = @ExampleObject(name = "500 Response", summary = "Handle exception when internal server error", value = """
                            {
                              "timestamp": "2023-10-19T06:35:52.333+00:00",
                              "status": 500,
                              "path": "/api/v1/...",
                              "error": "Internal Server Error",
                              "message": "Connection timeout, please try again"
                            }
                            """)) })
    })
    public ErrorResponse handleException(Exception e, WebRequest request) {
        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setTimestamp(new Date());
        errorResponse.setPath(request.getDescription(false).replace("uri=", ""));
        errorResponse.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
        errorResponse.setError(HttpStatus.INTERNAL_SERVER_ERROR.getReasonPhrase());
        errorResponse.setMessage(e.getMessage());

        return errorResponse;
    }

    /**
     * Handle exception when token expired
     *
     * @param e
     * @param request
     * @return error
     */
    @ExceptionHandler(JwtException.class)
    @ResponseStatus(HttpStatus.OK)
    @ApiResponses(value = {
            @ApiResponse(responseCode = "401", description = "Unauthorized", content = {
                    @Content(mediaType = APPLICATION_JSON_VALUE, examples = @ExampleObject(name = "401 Response", summary = "Handle exception when token expired", value = """
                            {
                              "timestamp": "2023-10-19T06:35:52.333+00:00",
                              "status": 401,
                              "path": "/api/v1/...",
                              "error": "Token Expired",
                              "message": "Connection timeout, please try again"
                            }
                            """)) })
    })
    public ErrorResponse handleJwtException(JwtException e, WebRequest request) {
        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setTimestamp(new Date());
        errorResponse.setPath(request.getDescription(false).replace("uri=", ""));
        errorResponse.setStatus(HttpStatus.UNAUTHORIZED.value());
        errorResponse.setError(HttpStatus.UNAUTHORIZED.getReasonPhrase());
        errorResponse.setMessage(e.getMessage());

        if (e instanceof io.jsonwebtoken.ExpiredJwtException) {
            errorResponse.setMessage("TOKEN_EXPIRED");
        } else {
            errorResponse.setMessage("INVALID_TOKEN");
        }

        return errorResponse;
    }

}
