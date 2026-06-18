(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	infrared3 - mode
	spectrograph0 - mode
	spectrograph1 - mode
	spectrograph2 - mode
	thermograph4 - mode
	Star0 - direction
	Star1 - direction
	GroundStation4 - direction
	Star7 - direction
	Star10 - direction
	Star11 - direction
	Star13 - direction
	Star6 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	GroundStation12 - direction
	GroundStation9 - direction
	Star8 - direction
	GroundStation2 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Planet16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 Star6)
	(supports instrument1 spectrograph0)
	(supports instrument1 spectrograph2)
	(supports instrument1 infrared3)
	(supports instrument1 thermograph4)
	(calibration_target instrument1 Star8)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation12)
	(calibration_target instrument1 GroundStation5)
	(supports instrument2 spectrograph1)
	(supports instrument2 infrared3)
	(calibration_target instrument2 GroundStation2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
)
(:goal (and
	(have_image Phenomenon14 spectrograph1)
	(have_image Planet15 spectrograph1)
	(have_image Planet16 spectrograph0)
	(have_image Planet17 spectrograph0)
))

)
