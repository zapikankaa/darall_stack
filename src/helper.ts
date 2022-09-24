// функции, конвертирующие значения необязательных полей

function convertExpectedNumber(num: any) {
  let converted

  if (typeof num === 'string') {
    if (num.length === 0) converted = null
    else converted = Number(num)
  } else converted = undefined

  return converted
}

function convertExpectedString(str: any) {
  let converted

  if (str === '') converted = null
  else if (str === null) converted = undefined
  else converted = str

  return converted
}

export {
  convertExpectedNumber,
  convertExpectedString
}