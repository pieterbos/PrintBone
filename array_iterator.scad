/**
 *gives a [start:step:end] array that guarantees to include end. uglyness :)
 */
function array_iterator(start, step, end) =
    let(result = [for (i=[start:step:end]) i ]) 
    abs(result[len(result)-1] - end) < 0.000001 ? result :
    concat(
        result,
        [end]
    );
    